import 'dart:convert';
import 'dart:typed_data';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/api_error.dart';
import 'package:d_reader_flutter/core/models/buy_nft_input.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/auction_house_provider.dart';
import 'package:d_reader_flutter/core/providers/candy_machine_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/signature_status_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_auth_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/base58.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

final solanaProvider =
    StateNotifierProvider<SolanaClientNotifier, SolanaClientState>(
  (ref) {
    return SolanaClientNotifier(ref);
  },
);

@immutable // preferred to use immutable states
class SolanaClientState {
  const SolanaClientState();
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
  final StateNotifierProviderRef ref;

  SolanaClientNotifier(
    this.ref,
  ) : super(const SolanaClientState());

  Future<String?> requestAirdrop(String publicKey) async {
    try {
      final client = SolanaClient(
        rpcUrl: Uri.parse(
          Config.solanaRpcDevnet,
        ),
        websocketUrl: Uri.parse(
          "ws://api.devnet.solana.com",
        ),
      );
      await client.rpcClient.requestAirdrop(
        publicKey,
        2 * lamportsPerSol,
        commitment: Commitment.finalized,
      );
      return "You have received 2 SOL";
    } on HttpException catch (error) {
      var message = error.toString();
      // sentry log error;
      if (message.contains('429')) {
        return "Too many requests. Try again later.";
      } else if (message.contains('500')) {}
      return "Airdrop has failed.";
    } catch (error) {
      //log error
      return null;
    }
  }

  Future<String> authorizeAndSignMessage([String? overrideCluster]) async {
    final session = await _getSession();
    final client = await session.start();
    final String cluster =
        overrideCluster ?? ref.read(environmentProvider).solanaCluster;
    final result = await client.authorize(
      identityUri: Uri.parse('https://dreader.io/'),
      identityName: 'dReader',
      cluster: cluster,
      iconUri: Uri.file(Config.faviconPath),
    );
    final publicKey = Ed25519HDPublicKey(result?.publicKey ?? []);
    final apiUrl = cluster == SolanaCluster.devnet.value
        ? Config.apiUrlDevnet
        : Config.apiUrl;
    final envNotifier = ref.read(environmentProvider.notifier);
    final signMessageResult = await _signMessage(
      client: client,
      signer: publicKey,
      overrideAuthToken: result?.authToken ?? '',
      apiUrl: apiUrl,
    );
    if (signMessageResult is String || signMessageResult.isEmpty) {
      await session.close();
      return signMessageResult is String
          ? signMessageResult
          : 'Failed to sign message.';
    }
    envNotifier.updateEnvironmentState(
      EnvironmentStateUpdateInput(
        publicKey: publicKey,
        authToken: result?.authToken,
        solanaCluster: cluster,
        apiUrl: apiUrl,
        signature: Signature(
          signMessageResult.first.sublist(0, 64),
          publicKey: publicKey,
        ).bytes,
      ),
    );
    envNotifier.updateLastSelectedNetwork(cluster);
    await session.close();

    await _getAndStoreToken(
      signedMessage: signMessageResult.first,
      publicKey: publicKey,
      apiUrl: apiUrl,
    );
    return 'OK';
  }

  Future<void> _getAndStoreToken({
    required Uint8List signedMessage,
    required Ed25519HDPublicKey publicKey,
    required String apiUrl,
  }) async {
    final response = await ref.read(authRepositoryProvider).connectWallet(
          address: publicKey.toBase58(),
          encoding: base58encode(
            signedMessage.sublist(
              signedMessage.length - 64,
              signedMessage.length,
            ),
          ),
          apiUrl: apiUrl,
        );
    if (response != null) {
      ref.read(environmentProvider.notifier).updateEnvironmentState(
            EnvironmentStateUpdateInput(
              jwtToken: response.accessToken,
              refreshToken: response.refreshToken,
            ),
          );
      if (ref.read(environmentProvider).solanaCluster ==
          SolanaCluster.devnet.value) {
        await ref.read(networkChangeUpdateWallet(publicKey.toBase58()).future);
      }
    }
  }

  Future<void> deauthorize() async {
    final authToken = ref.read(environmentProvider).authToken;
    if (authToken == null) return;

    final session = await _getSession();
    final client = await session.start();

    await client.deauthorize(authToken: authToken);
    await session.close();
  }

  Future<bool> mint(String? candyMachineAddress) async {
    if (candyMachineAddress == null) {
      return false;
    }
    final String? encodedNftTransaction = await ref
        .read(candyMachineRepositoryProvider)
        .constructNftTransaction(candyMachineAddress);
    if (encodedNftTransaction == null) {
      return false;
    }
    return await _signAndSendTransactions([encodedNftTransaction]);
  }

  Future<bool> list({
    required String mintAccount,
    required int price,
    String printReceipt = 'false',
  }) async {
    final String? encodedTransaction =
        await ref.read(auctionHouseRepositoryProvider).listItem(
              mintAccount: mintAccount,
              price: price,
              printReceipt: printReceipt,
            );
    if (encodedTransaction == null) {
      return false;
    }
    return await _signAndSendTransactions([encodedTransaction]);
  }

  Future<bool> delist({
    required String mint,
  }) async {
    final String? encodedTransaction =
        await ref.read(auctionHouseRepositoryProvider).delistItem(mint: mint);
    if (encodedTransaction == null) {
      return false;
    }
    return await _signAndSendTransactions([encodedTransaction]);
  }

  Future<bool> buyMultiple(List<BuyNftInput> input) async {
    Map<String, String> query = {};
    for (int i = 0; i < input.length; ++i) {
      query["instantBuyParams[$i]"] = jsonEncode(input[i].toJson());
    }
    final List<String> encodedTransactions =
        await ref.read(auctionHouseRepositoryProvider).buyMultipleItems(query);
    if (encodedTransactions.isEmpty) {
      return false;
    }
    return await _signAndSendTransactions(encodedTransactions);
  }

  SignedTx _decodeAndResign({
    required String encodedTransaction,
    required Signature signature,
  }) {
    final decodedTX = SignedTx.decode(encodedTransaction);
    return decodedTX.resign(signature);
  }

  Future<bool> _signAndSendTransactions(
      List<String> encodedTransactions) async {
    final session = await _getSession();
    final client = await session.start();
    final signature = _getSignature();
    ref.read(globalStateProvider.notifier).state.copyWith(isLoading: true);
    if (await _doReauthorize(client) && signature != null) {
      List<SignedTx> resignedTransactions = encodedTransactions
          .map(
            (encoded) => _decodeAndResign(
              encodedTransaction: encoded,
              signature: signature,
            ),
          )
          .toList();
      try {
        final response = await client.signAndSendTransactions(
          transactions: resignedTransactions.map((resignedTransaction) {
            return base64Decode(resignedTransaction.encode());
          }).toList(),
        );
        if (response.signatures.isNotEmpty) {
          ref.read(globalStateProvider.notifier).update(
                (state) => state.copyWith(
                  isLoading: false,
                  isMinting: true,
                ),
              );
          final transactionSignature =
              base58encode(response.signatures.first.toList());
          ref.read(mintingStatusProvider(transactionSignature));
        }
        Sentry.captureMessage(
          'Sign and send response $response',
          level: SentryLevel.info,
        );
      } catch (exception, stackTrace) {
        Sentry.captureException(exception, stackTrace: stackTrace);
      }
    }
    await session.close();
    return true;
  }

  Signature? _getSignature() {
    final envState = ref.read(environmentProvider);
    return envState.signature != null && envState.publicKey != null
        ? Signature(envState.signature?.codeUnits ?? [],
            publicKey: envState.publicKey!)
        : null;
  }

  Future<dynamic> _signMessage({
    required MobileWalletAdapterClient client,
    required Ed25519HDPublicKey signer,
    required String overrideAuthToken,
    required String apiUrl,
  }) async {
    if (await _doReauthorize(client, overrideAuthToken)) {
      final message = await ref.read(authRepositoryProvider).getOneTimePassword(
            address: signer.toBase58(),
            apiUrl: apiUrl,
          );
      if (message is ApiError) {
        return message.message;
      }
      final addresses = Uint8List.fromList(signer.bytes);

      final messageToBeSigned = Uint8List.fromList(utf8.encode(message));
      try {
        final result = await client.signMessages(
          messages: [messageToBeSigned],
          addresses: [addresses],
        );
        return result.signedPayloads;
      } catch (exception, stackTrace) {
        Sentry.captureException(exception, stackTrace: stackTrace);
      }
    }
    return [];
  }

  Future<bool> _doReauthorize(MobileWalletAdapterClient client,
      [String? overrideAuthToken]) async {
    final authToken =
        overrideAuthToken ?? ref.read(environmentProvider).authToken;
    if (authToken == null) {
      return false;
    }
    final result = await client.reauthorize(
      identityUri: Uri.parse('https://dreader.io/'),
      identityName: 'dReader',
      authToken: authToken,
      iconUri: Uri.file(Config.faviconPath),
    );
    ref.read(environmentProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            authToken: result?.authToken,
          ),
        );
    return result != null;
  }

  Future<LocalAssociationScenario> _getSession() async {
    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();
    return session;
  }
}
