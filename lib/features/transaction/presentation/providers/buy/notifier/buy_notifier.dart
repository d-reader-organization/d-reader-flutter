import 'dart:convert';

import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/auction_house/presentation/providers/auction_house_providers.dart';
import 'package:d_reader_flutter/features/digital_asset/domain/models/buy_digital_asset.dart';
import 'package:d_reader_flutter/features/transaction/domain/providers/transaction_provider.dart';
import 'package:d_reader_flutter/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:d_reader_flutter/features/transaction/presentation/providers/common/transaction_state.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_transactions_notifier.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_wallet_notifier.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/mwa_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/mwa_transaction_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'buy_notifier.g.dart';

List<Uint8List> _mapForSignAndSend(List<String> data) =>
    data.map(base64Decode).toList();

@riverpod
class BuyNotifier extends _$BuyNotifier {
  late final TransactionRepository _transactionRepository;

  @override
  TransactionState build() {
    _transactionRepository = ref.read(transactionRepositoryProvider);
    return const TransactionState.initialized();
  }

  Future<void> buy() async {
    state = const TransactionState.processing();

    final bool isLocalWallet = ref.read(selectedWalletProvider) ==
        ref.read(localWalletNotifierProvider).value?.address;

    if (!isLocalWallet) {
      return await _mwaBuyMultiple();
    }

    final apiResponse = await _getBuyTransactions(
      _buildBuyAssetsQuery(
        ref.read(localWalletNotifierProvider).value!.address,
      ),
    );
    apiResponse.when(
      ok: (data) => _localWalletSignAndSend(_mapForSignAndSend(data)),
      error: (message) {
        state = TransactionState.failed(message);
      },
    );
  }

  Map<String, String> _buildBuyAssetsQuery(String buyerAddress) {
    List<BuyDigitalAsset> selectedDigitalAssetsInput = ref
        .read(selectedListingsProvider)
        .map(
          (e) => BuyDigitalAsset(
            mintAccount: e.assetAddress,
            price: e.price,
            sellerAddress: e.seller.address,
            buyerAddress: buyerAddress,
          ),
        )
        .toList();
    Map<String, String> query = {};
    for (int i = 0; i < selectedDigitalAssetsInput.length; ++i) {
      query["instantBuyParams[$i]"] =
          jsonEncode(selectedDigitalAssetsInput[i].toJson());
    }
    return query;
  }

  Future<TransactionApiResponse<List<String>>> _getBuyTransactions(
          Map<String, String> query) =>
      _transactionRepository.buyMultipleItems(query).then(mapApiResponse);

  Future<void> _localWalletSignAndSend(List<Uint8List> transactions) async {
    final List<String> signatures = await ref
        .read(localTransactionsNotifierProvider.notifier)
        .signAndSendTransactions(transactions);
    state = signatures.isNotEmpty
        ? const TransactionState.success(successResult)
        : const TransactionState.failed(failedToSignTransactionsMessage);
  }

  Future<void> _mwaBuyMultiple() async {
    final String walletAddress =
        ref.read(environmentProvider).publicKey?.toBase58() ?? '';

    if (walletAddress.isNotEmpty) {
      return await _getMwaTransactionsAndSend(walletAddress);
    }

    final response = await ref
        .read(mwaNotifierProvider.notifier)
        .authorizeIfNeededWithOnComplete();

    response.fold(
      (exception) {
        state = TransactionState.failed(exception.message);
      },
      (data) async {
        await _getMwaTransactionsAndSend(
          ref.read(environmentProvider).publicKey!.toBase58(),
        );
      },
    );
  }

  Future<void> _getMwaTransactionsAndSend(String walletAddress) async {
    final apiResponse = await _getBuyTransactions(
      _buildBuyAssetsQuery(
        walletAddress,
      ),
    );
    apiResponse.when(
      ok: _mwaSignAndSend,
      error: (message) {
        state = TransactionState.failed(message);
      },
    );
  }

  Future<void> _mwaSignAndSend(List<String> data) async {
    final response = await ref
        .read(mwaTransactionNotifierProvider.notifier)
        .signAndSendWithWrapper(_mapForSignAndSend(data));
    response.fold(
      (exception) {
        state = TransactionState.failed(exception.message);
      },
      (data) {
        state = TransactionState.success(data);
      },
    );
  }
}
