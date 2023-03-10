import 'dart:convert';
import 'dart:typed_data';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/services/d_reader_wallet_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

final solanaProvider =
    StateNotifierProvider<SolanaClientNotifier, SolanaClientState>(
        (ref) => SolanaClientNotifier(DReaderWalletService.instance));

@immutable // preferred to use immutable states
class SolanaClientState {
  const SolanaClientState({
    this.authorizationResult,
  });
  final AuthorizationResult? authorizationResult;

  SolanaClientState copyWith({
    AuthorizationResult? authorizationResult,
  }) {
    return SolanaClientState(
      authorizationResult: authorizationResult,
    );
  }
}

extension ResignTx on SignedTx {
  SignedTx resign(Signature newSignature) => SignedTx(
        signatures: signatures.toList()
          ..removeAt(0)
          ..insert(0, newSignature),
        compiledMessage: compiledMessage,
      );
}

class SolanaClientNotifier extends StateNotifier<SolanaClientState> {
  SolanaClientNotifier(this._walletService)
      : super(const SolanaClientState(authorizationResult: null));
  final DReaderWalletService _walletService;

  Signature? _signature;

  Future<Uint8List?> authorizeAndSignMessage() async {
    final session = await _getSession();
    final client = await session.start();

    final result = await client.authorize(
      identityUri: Uri.parse('https://dreader.io/'),
      identityName: 'dReader',
      cluster: Config.solanaCluster,
    );
    state = state.copyWith(authorizationResult: result);
    final publicKey = Ed25519HDPublicKey(result?.publicKey ?? []);

    final signMessageResult = await _signMessage(client);
    _signature = Signature(
      signMessageResult.first.sublist(0, 64),
      publicKey: publicKey,
    );
    await session.close();
    return signMessageResult.isNotEmpty ? signMessageResult.first : null;
  }

  Future<String> getTokenAfterSigning(Uint8List signedMessage) async {
    return _walletService.connectWallet(
      Ed25519HDPublicKey(state.authorizationResult?.publicKey ?? []),
      signedMessage.sublist(
        signedMessage.length - 64,
        signedMessage.length,
      ),
    );
  }

  Future<void> deauthorize() async {
    final authToken = state.authorizationResult?.authToken;
    if (authToken == null) return;

    final session = await _getSession();
    final client = await session.start();

    await client.deauthorize(authToken: authToken);
    state = state.copyWith(authorizationResult: null);
    await session.close();
  }

  Future<bool> mint(String? candyMachineAddress) async {
    if (candyMachineAddress == null) {
      return false;
    }
    final String? encodedNftTransaction =
        await _walletService.getNftTransaction(candyMachineAddress);
    if (encodedNftTransaction == null) {
      return false;
    }
    return await _signAndSendTransaction(encodedNftTransaction);
  }

  Future<bool> list({
    required String mintAccount,
    required double price,
    String printReceipt = 'false',
  }) async {
    final String? encodedTransaction = await _walletService.listItem(
        mintAccount: mintAccount, price: price, printReceipt: printReceipt);
    if (encodedTransaction == null) {
      return false;
    }
    return await _signAndSendTransaction(encodedTransaction);
  }

  Future<bool> _signAndSendTransaction(String encodedTransaction) async {
    final decodedTX = SignedTx.decode(encodedTransaction);

    final session = await _getSession();
    final client = await session.start();

    if (await _doReauthorize(client)) {
      final finalTransaction = decodedTX.resign(_signature!);
      try {
        final response = await client.signAndSendTransactions(
          transactions: [
            base64Decode(
              finalTransaction.encode(),
            ),
          ],
        );
        print(response);
      } catch (e) {
        print(e);
      }
    }
    await session.close();
    return true;
  }

  Future<List<Uint8List>> _signMessage(MobileWalletAdapterClient client) async {
    if (await _doReauthorize(client)) {
      final signer = Ed25519HDPublicKey(state.authorizationResult!.publicKey);
      final message = await _walletService.getOneTimePassword(signer);
      final addresses = Uint8List.fromList(signer.bytes);

      final messageToBeSigned = Uint8List.fromList(utf8.encode(message));
      try {
        final result = await client.signMessages(
            messages: [messageToBeSigned], addresses: [addresses]);
        return result.signedPayloads;
      } catch (e) {
        print('Error - Sign message:  ${e.toString()}');
      }
    }
    return [];
  }

  Future<bool> _doReauthorize(MobileWalletAdapterClient client) async {
    final authToken = state.authorizationResult?.authToken;
    if (authToken == null) return false;
    final result = await client.reauthorize(
      identityUri: Uri.parse('https://dreader.io/'),
      identityName: 'dReader',
      authToken: authToken,
    );
    state = state.copyWith(authorizationResult: result);
    return result != null;
  }

  Future<LocalAssociationScenario> _getSession() async {
    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();
    return session;
  }
}
