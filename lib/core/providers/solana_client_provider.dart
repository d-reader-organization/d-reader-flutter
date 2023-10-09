import 'dart:convert';
import 'dart:typed_data';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/api_error.dart';
import 'package:d_reader_flutter/core/models/buy_nft_input.dart';
import 'package:d_reader_flutter/core/models/exceptions.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/auth/auth_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/signature_status_provider.dart';
import 'package:d_reader_flutter/core/providers/transaction/provider.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:d_reader_flutter/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/base58.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

const String missingWalletAppText = 'Missing wallet application.';

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

  Future<AuthorizationResult?> _authorize({
    required MobileWalletAdapterClient client,
    required String cluster,
  }) {
    return client.authorize(
      identityUri: Uri.parse('https://dreader.io/'),
      identityName: 'dReader',
      cluster: cluster,
      iconUri: Uri.file(Config.faviconPath),
    );
  }

  Future<String> authorizeAndSignMessage([
    String? overrideCluster,
    Function()? onStart,
  ]) async {
    final session = await _getSession();
    if (session == null) {
      throw Exception(missingWalletAppText);
    }
    final client = await session.start();
    final String cluster =
        overrideCluster ?? ref.read(environmentProvider).solanaCluster;
    if (onStart != null) {
      onStart();
    }
    final result = await _authorize(
      client: client,
      cluster: cluster,
    );

    final publicKey = Ed25519HDPublicKey(result?.publicKey ?? []);
    final apiUrl = cluster == SolanaCluster.devnet.value
        ? Config.apiUrlDevnet
        : Config.apiUrl;
    final envNotifier = ref.read(environmentProvider.notifier);
    final String jwtToken = ref.read(environmentProvider).jwtToken ?? '';
    if (jwtToken.isEmpty) {
      throw Exception('Missing jwt token');
    }
    final signMessageResult = await _signMessage(
      client: client,
      signer: publicKey,
      overrideAuthToken: result?.authToken ?? '',
      apiUrl: apiUrl,
      jwtToken: jwtToken,
    );
    if (signMessageResult is String || signMessageResult == null) {
      await session.close();
      return signMessageResult is String
          ? signMessageResult
          : 'Failed to sign message.';
    }

    if (signMessageResult is! SignedMessage) {
      return 'No signed message';
    }

    final currentWallets = ref.read(environmentProvider).wallets;
    final signedMessage =
        signMessageResult.signatures.first.toList().sublist(0, 64);
    envNotifier.updateEnvironmentState(
      EnvironmentStateUpdateInput(
        publicKey: publicKey,
        authToken: result?.authToken,
        solanaCluster: cluster,
        apiUrl: apiUrl,
        signature: Signature(
          signedMessage,
          publicKey: publicKey,
        ).bytes,
        wallets: {
          ...?currentWallets,
          publicKey.toBase58(): WalletData(
            authToken: result?.authToken ?? '',
            signature: Signature(
              signedMessage,
              publicKey: publicKey,
            ).toBase58(),
          ),
        },
      ),
    );
    await Future.wait(
      [
        session.close(),
        _connectWallet(
          signedMessage: signMessageResult.signatures.first,
          publicKey: publicKey,
          apiUrl: apiUrl,
          jwtToken: jwtToken,
        ),
      ],
    );

    return 'OK';
  }

  Future<void> _connectWallet({
    required Uint8List signedMessage,
    required Ed25519HDPublicKey publicKey,
    required String apiUrl,
    required String jwtToken,
  }) async {
    await ref.read(authRepositoryProvider).connectWallet(
          address: publicKey.toBase58(),
          encoding: base58encode(
            signedMessage.sublist(
              signedMessage.length - 64,
              signedMessage.length,
            ),
          ),
          apiUrl: apiUrl,
          jwtToken: jwtToken,
        );
  }

  Future<dynamic> mint(String? candyMachineAddress, String? label) async {
    if (candyMachineAddress == null) {
      return 'Candy machine not found.';
    }
    String? minterAddress = ref.read(environmentProvider).publicKey?.toBase58();
    if (minterAddress == null) {
      final result = await authorizeAndSignMessage();
      minterAddress = ref.read(environmentProvider).publicKey?.toBase58();
      if (result != 'OK' || minterAddress == null) {
        return 'Select/Connect wallet first';
      }
    }
    final List<dynamic> encodedNftTransactions =
        await ref.read(transactionRepositoryProvider).mintOneTransaction(
              candyMachineAddress: candyMachineAddress,
              minterAddress: minterAddress,
              label: label,
            );
    if (encodedNftTransactions.isEmpty) {
      return false;
    }
    try {
      for (String encodedTransaction in encodedNftTransactions) {
        await _signAndSendTransactions([encodedTransaction]);
      }
      return true;
    } catch (exception) {
      Sentry.captureException(exception);
      return false;
    }
  }

  Future<bool> list({
    required String sellerAddress,
    required String mintAccount,
    required int price,
    String printReceipt = 'false',
  }) async {
    final String? encodedTransaction =
        await ref.read(transactionRepositoryProvider).listTransaction(
              sellerAddress: sellerAddress,
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
    required String nftAddress,
  }) async {
    final String? encodedTransaction = await ref
        .read(transactionRepositoryProvider)
        .cancelListingTransaction(nftAddress: nftAddress);
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
        await ref.read(transactionRepositoryProvider).buyMultipleItems(query);
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

  Future<bool> useMint({
    required String nftAddress,
    required String ownerAddress,
  }) async {
    final String transaction = await ref
        .read(transactionRepositoryProvider)
        .useComicIssueNftTransaction(
          nftAddress: nftAddress,
          ownerAddress: ownerAddress,
        );
    return await _signAndSendTransactions([transaction]);
  }

  Future<bool> _signAndSendTransactions(
      List<String> encodedTransactions) async {
    final session = await _getSession();
    if (session == null) {
      throw Exception(missingWalletAppText);
    }
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
        final response = await client.signTransactions(
          transactions: resignedTransactions.map((resignedTransaction) {
            return base64Decode(resignedTransaction.encode());
          }).toList(),
        );
        await session.close();
        if (response.signedPayloads.isNotEmpty) {
          final client = createSolanaClient(
            rpcUrl: ref.read(environmentProvider).solanaCluster ==
                    SolanaCluster.devnet.value
                ? Config.rpcUrlDevnet
                : Config.rpcUrlMainnet,
          );

          final signedTx = SignedTx.fromBytes(
            response.signedPayloads.first.toList(),
          );
          final sendTransactionResult = await client.rpcClient.sendTransaction(
            signedTx.encode(),
            preflightCommitment: Commitment.confirmed,
          );
          ref.read(globalStateProvider.notifier).update(
                (state) => state.copyWith(
                  isLoading: false,
                  isMinting: true,
                ),
              );
          ref.read(mintingStatusProvider(sendTransactionResult));
          return true;
        }
      } catch (exception, stackTrace) {
        await session.close();
        Sentry.captureException(exception, stackTrace: stackTrace);
      }
    }
    await session.close();
    return false;
  }

  Signature? _getSignature() {
    final envState = ref.read(environmentProvider);
    return envState.signature != null && envState.publicKey != null
        ? Signature(
            envState.signature?.codeUnits ?? [],
            publicKey: envState.publicKey!,
          )
        : null;
  }

  Future<dynamic> _signMessage({
    required MobileWalletAdapterClient client,
    required Ed25519HDPublicKey signer,
    required String overrideAuthToken,
    required String apiUrl,
    required String jwtToken,
  }) async {
    if (await _doReauthorize(client, overrideAuthToken)) {
      final message = await ref.read(authRepositoryProvider).getOneTimePassword(
            address: signer.toBase58(),
            apiUrl: apiUrl,
            jwtToken: jwtToken,
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
        return result.signedMessages.first;
      } catch (exception, stackTrace) {
        Sentry.captureException(exception, stackTrace: stackTrace);
      }
    }
    return null;
  }

  Future<bool> _doReauthorize(MobileWalletAdapterClient client,
      [String? overrideAuthToken]) async {
    final envState = ref.read(environmentProvider);
    final currentWalletAddress = envState.publicKey?.toBase58() ?? '';
    final walletAuthToken = envState.wallets?[currentWalletAddress]?.authToken;

    final authToken = overrideAuthToken ??
        walletAuthToken ??
        ref.read(environmentProvider).authToken;
    if (authToken == null) {
      return false;
    }
    var result = await client.reauthorize(
      identityUri: Uri.parse('https://dreader.io/'),
      identityName: 'dReader',
      authToken: authToken,
      iconUri: Uri.file(Config.faviconPath),
    );

    result ??= await client.authorize(
      identityUri: Uri.parse('https://dreader.io/'),
      identityName: 'dReader',
      cluster: envState.solanaCluster,
      iconUri: Uri.file(Config.faviconPath),
    );
    final walletsMap = envState.wallets;
    final currentItem = walletsMap?[currentWalletAddress];

    ref.read(environmentProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            authToken: result?.authToken,
            wallets: currentItem != null
                ? {
                    ...?walletsMap,
                    currentWalletAddress: WalletData(
                      authToken: result?.authToken ?? '',
                      signature: currentItem.signature,
                    ),
                  }
                : null,
          ),
        );
    return result != null;
  }

  Future<LocalAssociationScenario?> _getSession() async {
    final bool isWalletAvailable = await LocalAssociationScenario.isAvailable();

    if (!isWalletAvailable) {
      throw NoWalletFoundException(missingWalletAppText);
    }

    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();

    return session;
  }
}
