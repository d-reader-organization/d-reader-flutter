import 'dart:convert' show base64Decode;

import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/notifiers/candy_machine_notifier.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/features/transaction/presentation/providers/common/transaction_state.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/providers/digital_asset_providers.dart';
import 'package:d_reader_flutter/features/transaction/domain/providers/transaction_provider.dart';
import 'package:d_reader_flutter/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_transactions_notifier.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_wallet_notifier.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/mwa_transaction_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mint_notifier.g.dart';

@riverpod
class MintNotifier extends _$MintNotifier {
  late final TransactionRepository _transactionRepository;

  @override
  TransactionState build() {
    _transactionRepository = ref.read(transactionRepositoryProvider);
    return const TransactionState.initialized();
  }

  Future<bool> _shouldProceedMint() async {
    CandyMachineModel? candyMachineState = ref.read(candyMachineStateProvider);
    if (candyMachineState == null) {
      state = const TransactionState.failed('Failed to find candy machine');
      return false;
    }

    return true;
  }

  bool _hasEligibility() {
    final hasEligibility = hasEligibilityForMint(
        ref.read(candyMachineNotifierProvider).selectedCoupon);
    if (!hasEligibility) {
      state = TransactionState.failed(_noEligibilityMessage());
      return false;
    }
    return true;
  }

  String _noEligibilityMessage() {
    return 'User ${ref.read(environmentProvider).user?.email} is not eligible for minting';
  }

  Future<void> mint(String candyMachineAddress) async {
    state = const TransactionState.processing();
    final proceedMint = await _shouldProceedMint();
    if (!proceedMint) {
      return;
    }
    final bool isLocalWallet =
        ref.read(localWalletNotifierProvider).value?.address ==
            ref.read(selectedWalletProvider);

    if (!isLocalWallet) {
      return await _mwaSignAndSend(candyMachineAddress);
    }

    final apiResponse = await _getMintTransactions(
      candyMachineAddress: candyMachineAddress,
      walletAddress: ref.read(selectedWalletProvider),
    );

    apiResponse.when(
      ok: (data) async {
        final transactions = data.map(base64Decode).toList();
        if (_hasEligibility()) {
          await _localWalletSignAndSend(transactions);
        }
      },
      error: (message) {
        state = TransactionState.failed(message);
      },
    );
  }

  Future<TransactionApiResponse<List<String>>> _getMintTransactions({
    required String candyMachineAddress,
    required String walletAddress,
  }) async {
    final data = ref.read(candyMachineNotifierProvider);
    return _transactionRepository
        .mintTransaction(
          couponId: data.selectedCoupon?.id ?? 1,
          numberOfItems: data.numberOfItems,
          candyMachineAddress: candyMachineAddress,
          minterAddress: walletAddress,
          label: data.selectedCurrency?.label ?? '',
        )
        .then(mapApiResponse);
  }

  Future<void> _localWalletSignAndSend(List<Uint8List> transactions) async {
    final List<String> signatures = await ref
        .read(localTransactionsNotifierProvider.notifier)
        .signAndSendTransactions(transactions);

    _listenToSignatureStatus(signatures);
    state = signatures.isNotEmpty
        ? const TransactionState.success(successResult)
        : const TransactionState.failed(failedToSignTransactionsMessage);
  }

  Future<void> _mwaSignAndSend(String candyMachineAddress) async {
    final response = await ref
        .read(mwaTransactionNotifierProvider.notifier)
        .mint(candyMachineAddress);

    response.fold(
      (exception) {
        state = TransactionState.failed(exception.message);
      },
      (data) {
        state = TransactionState.success(data);
      },
    );
  }

  _listenToSignatureStatus(List<String> signatures) => signatures.isNotEmpty
      ? ref.read(
          transactionChainStatusProvider(
            signatures.last,
          ),
        )
      : null;
}
