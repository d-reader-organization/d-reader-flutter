import 'dart:convert';

import 'package:d_reader_flutter/features/transaction/domain/providers/transaction_provider.dart';
import 'package:d_reader_flutter/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/local_wallet/local_wallet.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_wallet_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/solana/solana_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/encoder.dart';

part 'local_transactions_notifier.g.dart';

abstract class _LocalTransactionsInterface {
  Future<void> signAndSendTransactions(List<Uint8List> transactions);
}

@riverpod
class LocalTransactionsNotifier extends _$LocalTransactionsNotifier
    implements _LocalTransactionsInterface {
  late final TransactionRepository _transactionRepository;
  late final LocalWallet _wallet;

  @override
  void build() {
    _transactionRepository = ref.read(transactionRepositoryProvider);
    _wallet = ref.read(localWalletNotifierProvider).value!;
  }

  Future<List<Uint8List>> _getMintTransactions(
    String candyMachineAddress,
  ) async {
    return _getMintOneTransaction(
            candyMachineAddress: candyMachineAddress,
            walletAddress: _wallet.address)
        .then(
      (value) => value.map(_getBase64Decode).toList(),
    );
  }

  Future<void> handleMintWithLocalWallet({
    required String candyMachineAddress,
    required VoidCallback onSuccess,
  }) async {
    await signAndSendTransactions(
      await _getMintTransactions(
        candyMachineAddress,
      ),
    ).then((value) {
      onSuccess();
    });
  }

  @override
  Future<void> signAndSendTransactions(List<Uint8List> transactions) async {
    final List<SignedTx> signedTxs = await _signTransactions(transactions);
    await _sendTransactions(signedTxs);
  }

  Future<List<String>> _getMintOneTransaction({
    required String candyMachineAddress,
    required String walletAddress,
  }) async {
    return _transactionRepository
        .mintOneTransaction(
          candyMachineAddress: candyMachineAddress,
          minterAddress: walletAddress,
        )
        .then(
          (value) => value.fold(
            (exception) => [],
            (data) => data,
          ),
        );
  }

  Future<List<SignedTx>> _signTransactions(List<Uint8List> transactions) async {
    final payloads = transactions.map(SignedTx.fromBytes).toList();
    final preparedForSigning = payloads.map(
      (e) => Uint8List.fromList(e.compiledMessage.toByteArray().toList()),
    );

    final signatures = await _wallet.sign(preparedForSigning);

    final List<SignedTx> signedTxs = [];

    for (var i = 0; i < payloads.length; ++i) {
      final tx = payloads[i];
      final signature = signatures[i];

      signedTxs.add(
        SignedTx(
          compiledMessage: tx.compiledMessage,
          signatures: tx.signatures
              .map(
                (e) => e.publicKey == _wallet.publicKey ? signature : e,
              )
              .toList(),
        ),
      );
    }
    return signedTxs;
  }

  Future<void> _sendTransactions(List<SignedTx> signedTxs) async {
    for (final signedTx in signedTxs) {
      await ref
          .read(solanaClientProvider)
          .rpcClient
          .sendTransaction(signedTx.encode(), skipPreflight: true);
    }
  }
}

Uint8List _getBase64Decode(String value) => base64Decode(value);
