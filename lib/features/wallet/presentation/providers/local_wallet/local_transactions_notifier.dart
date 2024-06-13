import 'dart:convert' show base64Decode;

import 'package:d_reader_flutter/features/digital_asset/presentation/providers/digital_asset_providers.dart';
import 'package:d_reader_flutter/features/transaction/domain/providers/transaction_provider.dart';
import 'package:d_reader_flutter/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/local_wallet/local_wallet.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_wallet_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/solana_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';

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

  Future<void> handleList({
    required String assetAddress,
    required String sellerAddress,
    required double price,
  }) async {
    final listTransaction = await _getListTransaction(
      assetAddress: assetAddress,
      sellerAddress: sellerAddress,
      price: (price * lamportsPerSol).round(),
    );
    await signAndSendTransactions([base64Decode(listTransaction)]);
    ref.invalidate(digitalAssetsProvider);
    ref.invalidate(digitalAssetProvider);
  }

  Future<void> handleUnwrap({
    required String assetAddress,
    required String ownerAddress,
  }) async {
    final unwrapTransaction = await _getUnwrapTransaction(
      assetAddress: assetAddress,
      ownerAddress: ownerAddress,
    );
    await signAndSendTransactions([base64Decode(unwrapTransaction)]);
    ref.invalidate(digitalAssetsProvider);
    ref.invalidate(digitalAssetProvider);
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

  Future<String> _getListTransaction({
    required String assetAddress,
    required String sellerAddress,
    required int price,
  }) async {
    final response =
        await ref.read(transactionRepositoryProvider).listTransaction(
              sellerAddress: sellerAddress,
              mintAccount: assetAddress,
              price: price,
            );

    return response.fold(
      (exception) => '',
      (data) => data,
    );
  }

  Future<String> _getUnwrapTransaction({
    required String assetAddress,
    required String ownerAddress,
  }) async {
    return _transactionRepository
        .useComicIssueAssetTransaction(
          digitalAssetAddress: assetAddress,
          ownerAddress: ownerAddress,
        )
        .then(
          (value) => value.fold(
            (exception) => '',
            (data) => data ?? '',
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
