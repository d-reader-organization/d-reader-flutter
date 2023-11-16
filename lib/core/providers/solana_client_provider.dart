import 'dart:convert';
import 'dart:typed_data';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/core/models/api_error.dart';
import 'package:d_reader_flutter/core/models/buy_nft_input.dart';
import 'package:d_reader_flutter/core/models/exceptions.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/auth/auth_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/signature_status_provider.dart';
import 'package:d_reader_flutter/core/providers/transaction/provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:d_reader_flutter/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:power/power.dart';
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
  // remove this
  const SolanaClientState();
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

  /* 
  1. Wallet aaa...aaa is not authorized on the dReader mobile app. Would you like to grant dReader the rights to communicate with your mobile wallet? - Wallet list screen
  - Trigger dialog with text above
  - Create method that will do Authorize only and store auth result in Environment. Double check if it does update Local store (both public key and wallets property)

  2. Remove resign method and test if everything works. - DONE

  3. When auth token missing, trigger authorize and sign message in the SAME wallet session. (sign message ONLY if wallet is not authorized on Backend)
  - Refactor each method to do authorize if needed (same session)
  - Basically when user start mint/lint/delist/buy:
  -- No Wallet Scenario/Wallet is there, but no auth token - user clicks on mint, if there is no wallet address present, trigger authorize & signmessage(if needed) in the same wallet session.
  */

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

  Future<String> authorizeWithOnComplete([
    String? overrideCluster,
    Function()? onStart,
    Future Function()? onComplete,
  ]) async {
    late LocalAssociationScenario session;
    try {
      session = await _getSession();
    } catch (exception) {
      if (exception is LowPowerModeException ||
          exception is NoWalletFoundException) {
        rethrow;
      }

      Sentry.captureException(exception);
      return 'Something went wrong.';
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
    if (result == null) {
      return 'Failed to authorize wallet.';
    }
    final publicKey = Ed25519HDPublicKey(result.publicKey);
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
      overrideAuthToken: result.authToken,
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
    envNotifier.updateEnvironmentState(
      EnvironmentStateUpdateInput(
        publicKey: publicKey,
        authToken: result.authToken,
        solanaCluster: cluster,
        apiUrl: apiUrl,
        wallets: {
          ...?currentWallets,
          publicKey.toBase58(): WalletData(
            authToken: result.authToken,
          ),
        },
      ),
    );
    ref.invalidate(registerWalletToSocketEvents);
    await _connectWallet(
      signedMessage: signMessageResult.signatures.first,
      publicKey: publicKey,
      apiUrl: apiUrl,
      jwtToken: jwtToken,
    );
    if (onComplete != null) {
      await onComplete();
    }
    await session.close();
    return 'OK';
  }

  Future<String> authorizeAndSignMessage([
    String? overrideCluster,
    Function()? onStart,
  ]) async {
    late LocalAssociationScenario session;
    try {
      session = await _getSession();
    } catch (exception) {
      if (exception is LowPowerModeException ||
          exception is NoWalletFoundException) {
        rethrow;
      }

      Sentry.captureException(exception);
      return 'Something went wrong.';
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
    envNotifier.updateEnvironmentState(
      EnvironmentStateUpdateInput(
        publicKey: publicKey,
        authToken: result?.authToken,
        solanaCluster: cluster,
        apiUrl: apiUrl,
        wallets: {
          ...?currentWallets,
          publicKey.toBase58(): WalletData(
            authToken: result?.authToken ?? '',
          ),
        },
      ),
    );
    ref.invalidate(registerWalletToSocketEvents);
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
    try {
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
    } catch (exception, stackTrace) {
      Sentry.captureMessage('Connect wallet exception $exception');
      Sentry.captureException(exception, stackTrace: stackTrace);
      throw Exception(exception);
    }
  }

  Future<dynamic> mint(String? candyMachineAddress, String? label) async {
    if (candyMachineAddress == null) {
      return 'Candy machine not found.';
    }
    String? minterAddress = ref.read(environmentProvider).publicKey?.toBase58();
    try {
      if (minterAddress == null) {
        final result =
            await authorizeAndSignMessage(); // update this call to be authorizeAndSignWithOnComplete. On complete should be bottom part.
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
      return _signAndSendMint(encodedNftTransactions);
    } catch (exception) {
      rethrow;
    }
  }

  Future<dynamic> _signAndSendMint(List encodedNftTransactions) async {
    late LocalAssociationScenario session;
    try {
      session = await _getSession();
    } catch (exception) {
      if (exception is LowPowerModeException ||
          exception is NoWalletFoundException) {
        rethrow;
      }
      Sentry.captureException(exception);
      return 'Something went wrong.';
    }

    final client = await session.start();

    ref.read(globalStateProvider.notifier).state.copyWith(isLoading: true);

    if (await _doReauthorize(client)) {
      try {
        final response = await client.signTransactions(
          transactions: encodedNftTransactions.map((transaction) {
            return base64Decode(transaction);
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
          String sendTransactionResult = '';
          for (final signedPayload in response.signedPayloads) {
            final signedTx = SignedTx.fromBytes(
              signedPayload.toList(),
            );
            sendTransactionResult = await client.rpcClient.sendTransaction(
              signedTx.encode(),
              preflightCommitment: Commitment.confirmed,
            );
          }
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
        if (exception is JsonRpcException) {
          return exception.message;
        }
      }
    }
    await session.close();
    return false;
  }

  Future<bool> list({
    required String sellerAddress,
    required String mintAccount,
    required int price,
    String printReceipt = 'false',
  }) async {
    try {
      // update method to check for public key
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
    } catch (exception) {
      if (exception is LowPowerModeException ||
          exception is NoWalletFoundException) {
        rethrow;
      }
      Sentry.captureException(exception);
      return false;
    }
  }

  Future<bool> delist({
    // check for wallet. authorizeAndSignWithComplete
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
    // check for wallet, authorizeAndSignWithComplete
    try {
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
    } catch (exception) {
      if (exception is LowPowerModeException ||
          exception is NoWalletFoundException) {
        rethrow;
      }
      return false;
    }
  }

  Future<dynamic> useMint({
    required String nftAddress,
    required String ownerAddress,
  }) async {
    // authoirze and sign with complete
    final String transaction = await ref
        .read(transactionRepositoryProvider)
        .useComicIssueNftTransaction(
          nftAddress: nftAddress,
          ownerAddress: ownerAddress,
        );
    return await _signAndSendTransactions([transaction]);
  }

  Future<dynamic> _signAndSendTransactions(
      List<String> encodedTransactions) async {
    late LocalAssociationScenario session;
    try {
      session = await _getSession();
    } catch (exception) {
      if (exception is LowPowerModeException ||
          exception is NoWalletFoundException) {
        rethrow;
      }
      Sentry.captureException(exception);
      return 'Something went wrong.';
    }

    final client = await session.start();
    ref.read(globalStateProvider.notifier).state.copyWith(isLoading: true);

    if (await _doReauthorize(client)) {
      try {
        final response = await client.signTransactions(
          transactions: encodedTransactions.map((transaction) {
            return base64Decode(transaction);
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
        if (exception is JsonRpcException) {
          return exception.message;
        }
      }
    }
    await session.close();
    return false;
  }

  Future<dynamic> _signMessage({
    required MobileWalletAdapterClient client,
    required Ed25519HDPublicKey signer,
    required String overrideAuthToken,
    required String apiUrl,
    required String jwtToken,
  }) async {
    if (await _doReauthorize(client, overrideAuthToken, signer.toBase58())) {
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
      [String? overrideAuthToken, String? overrideSigner]) async {
    final envState = ref.read(environmentProvider);
    final currentWalletAddress =
        overrideSigner ?? envState.publicKey?.toBase58() ?? '';
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

    ref.read(environmentProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(authToken: result?.authToken, wallets: {
            ...?walletsMap,
            currentWalletAddress: WalletData(
              authToken: result?.authToken ?? '',
            ),
          }),
        );
    return result != null;
  }

  Future<LocalAssociationScenario> _getSession() async {
    final bool isWalletAvailable = await LocalAssociationScenario.isAvailable();
    final bool isLowPowerMode = await Power.isLowPowerMode;
    if (isLowPowerMode) {
      throw LowPowerModeException(powerSaveModeText);
    }
    if (!isWalletAvailable) {
      throw NoWalletFoundException(missingWalletAppText);
    }

    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();

    return session;
  }
}
