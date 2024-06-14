import 'dart:convert' show base64Decode;

import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/enums.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/providers/digital_asset_providers.dart';
import 'package:d_reader_flutter/features/transaction/domain/providers/transaction_provider.dart';
import 'package:d_reader_flutter/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:d_reader_flutter/features/transaction/presentation/providers/common/transaction_state.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_transactions_notifier.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_wallet_notifier.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/data/local/local_store.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/mwa_transaction_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'unwrap_notifier.g.dart';

@riverpod
class UnwrapNotifier extends _$UnwrapNotifier {
  late final TransactionRepository _transactionRepository;

  @override
  // accepts parameter in order to handle multiple listeners properly - at the same level (bottom sheet)
  TransactionState build([String? address]) {
    _transactionRepository = ref.read(transactionRepositoryProvider);
    return const TransactionState.initialized();
  }

  Future<void> unwrapDigitalAsset({
    required String digitalAssetAddress,
    required String ownerAddress,
    bool ignoreDialog = false,
  }) async {
    state = const TransactionState.processing();

    if (!ignoreDialog) {
      final showUnwrapDialog =
          LocalStore.instance.get(WalkthroughKeys.unwrap.name) == null;
      if (showUnwrapDialog) {
        state = const TransactionState.showDialog();
        return;
      }
    }

    final apiResponse = await _getUnwrapTransaction(
      digitalAssetAddress: digitalAssetAddress,
      ownerAddress: ownerAddress,
    );

    apiResponse.when(
      ok: (data) async {
        if (data.isEmpty) {
          // if data is empty, that means it's Core Digital Asset which means it's unwrapped
          return _handleCoreAssetUnwrap(digitalAssetAddress);
        }
        final bool isLocalWallet = ref.read(selectedWalletProvider) ==
            ref.read(localWalletNotifierProvider).value?.address;
        final decodedTransactions = [base64Decode(data)];

        isLocalWallet
            ? _localWalletSignAndSend(decodedTransactions)
            : _mwaSignAndSend(decodedTransactions);
      },
      error: (message) {
        state = TransactionState.failed(message);
      },
    );
  }

  Future<TransactionApiResponse<String>> _getUnwrapTransaction({
    required String digitalAssetAddress,
    required String ownerAddress,
  }) async {
    return await _transactionRepository
        .useComicIssueAssetTransaction(
          digitalAssetAddress: digitalAssetAddress,
          ownerAddress: ownerAddress,
        )
        .then(mapApiResponse);
  }

  void _handleCoreAssetUnwrap(String digitalAssetAddress) {
    ref
        .read(lastProcessedAssetProvider.notifier)
        .update((state) => digitalAssetAddress);
    state = const TransactionState.success(successResult);
    return;
  }

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
