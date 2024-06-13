import 'dart:convert';

import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/transaction/domain/providers/transaction_provider.dart';
import 'package:d_reader_flutter/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:d_reader_flutter/features/transaction/presentation/providers/common/transaction_state.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_transactions_notifier.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_wallet_notifier.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/mwa_transaction_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/solana.dart' show lamportsPerSol;

part 'list_notifier.g.dart';

@riverpod
class ListNotifier extends _$ListNotifier {
  late final TransactionRepository _transactionRepository;

  @override
  TransactionState build() {
    _transactionRepository = ref.read(transactionRepositoryProvider);
    return const TransactionState.initialized();
  }

  Future<void> list({
    required String assetAddress,
    required String sellerAddress,
    required double price,
  }) async {
    state = const TransactionState.processing();
    await _getListTransaction(
      mintAccount: assetAddress,
      sellerAddress: sellerAddress,
      price: price,
    ).then(_handleApiResponse);
  }

  Future<void> delist(String assetAddress) async {
    state = const TransactionState.processing();
    await _getDelistTransaction(assetAddress).then(_handleApiResponse);
  }

  FutureOr<void> _handleApiResponse(
          TransactionApiResponse<String> apiResponse) =>
      apiResponse.when(
        ok: (data) async {
          final bool isLocalWallet =
              ref.read(localWalletNotifierProvider).value?.address ==
                  ref.read(selectedWalletProvider);
          final decodedTransaction = [base64Decode(data)];

          return isLocalWallet
              ? _localWalletSignAndSend(decodedTransaction)
              : _mwaSignAndSend(decodedTransaction);
        },
        error: (message) {
          state = TransactionState.failed(message);
          return;
        },
      );

  Future<TransactionApiResponse<String>> _getListTransaction({
    required String sellerAddress,
    required String mintAccount,
    required double price,
  }) =>
      _transactionRepository
          .listTransaction(
            sellerAddress: sellerAddress,
            mintAccount: mintAccount,
            price: (price * lamportsPerSol).round(),
          )
          .then(mapApiResponse<String>);

  Future<TransactionApiResponse<String>> _getDelistTransaction(
          String assetAddress) =>
      _transactionRepository
          .cancelListingTransaction(
            digitalAssetAddress: assetAddress,
          )
          .then(mapApiResponse<String>);

  Future<void> _localWalletSignAndSend(List<Uint8List> transactions) async {
    final List<String> signatures = await ref
        .read(localTransactionsNotifierProvider.notifier)
        .signAndSendTransactions(transactions);
    state = signatures.isNotEmpty
        ? const TransactionState.success(successResult)
        : const TransactionState.failed(failedToSignTransactionsMessage);
  }

  Future<void> _mwaSignAndSend(List<Uint8List> transactions) async {
    final response = await ref
        .read(mwaTransactionNotifierProvider.notifier)
        .signAndSendWithWrapper(transactions);

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
