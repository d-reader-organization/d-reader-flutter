import 'package:d_reader_flutter/features/wallet/domain/models/local_wallet/local_wallet.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_wallet_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/solana_providers.dart';
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
  late final LocalWallet _wallet;

  @override
  void build() {
    _wallet = ref.read(localWalletNotifierProvider).value!;
  }

  /// Returns list of transactions signatures
  @override
  Future<List<String>> signAndSendTransactions(
    List<Uint8List> transactions,
  ) async {
    final List<SignedTx> signedTxs = await _signTransactions(transactions);
    if (signedTxs.isEmpty) {
      return [];
    }
    return await _sendTransactions(signedTxs);
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

  Future<List<String>> _sendTransactions(List<SignedTx> signedTxs) async {
    List<String> transactionSignatures = [];
    for (final signedTx in signedTxs) {
      final String signature = await ref
          .read(solanaClientProvider)
          .rpcClient
          .sendTransaction(signedTx.encode(), skipPreflight: true);
      transactionSignatures.add(signature);
    }
    return transactionSignatures;
  }
}
