import 'dart:convert';
import 'dart:typed_data';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/core/providers/candy_machine_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/signature_status_provider.dart';
import 'package:d_reader_flutter/core/providers/transaction/provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/features/authentication/domain/providers/auth_provider.dart';
import 'package:d_reader_flutter/features/nft/domain/models/buy_nft.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:d_reader_flutter/shared/domain/providers/solana/solana_providers.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:d_reader_flutter/ui/utils/candy_machine_utils.dart';
import 'package:d_reader_flutter/ui/utils/formatter.dart';
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

  Future<String> _authorizeAndSignIfNeeded({
    required MobileWalletAdapterClient client,
    bool shouldSignMessage = false,
    String? overrideCluster,
  }) async {
    final cluster =
        overrideCluster ?? ref.read(environmentProvider).solanaCluster;
    final result = await _authorize(
      client: client,
      cluster: cluster,
    );
    if (result == null) {
      return 'Failed to authorize wallet.';
    }
    final envNotifier = ref.read(environmentProvider.notifier);
    final publicKey = Ed25519HDPublicKey(result.publicKey);
    final currentWallets = ref.read(environmentProvider).wallets;
    envNotifier.updateEnvironmentState(
      EnvironmentStateUpdateInput(
        publicKey: publicKey,
        authToken: result.authToken,
        solanaCluster: cluster,
        wallets: {
          ...?currentWallets,
          publicKey.toBase58(): WalletData(
            authToken: result.authToken,
          ),
        },
      ),
    );
    if (shouldSignMessage) {
      return await _signMessage2(
        client: client,
        signer: publicKey,
        authToken: result.authToken,
      );
    }
    ref.invalidate(registerWalletToSocketEvents);
    ref.read(registerWalletToSocketEvents);
    return 'OK';
  }

  Future<dynamic> _signMessage2({
    required MobileWalletAdapterClient client,
    required final Ed25519HDPublicKey signer,
    required final String authToken,
  }) async {
    final envState = ref.read(environmentProvider);
    final signMessageResult = await _signMessage(
      client: client,
      signer: signer,
      overrideAuthToken: authToken,
      apiUrl: envState.apiUrl,
      jwtToken: envState.jwtToken ?? '',
    );
    if (signMessageResult is String || signMessageResult == null) {
      return signMessageResult is String
          ? signMessageResult
          : 'Failed to sign message.';
    }

    if (signMessageResult is! SignedMessage) {
      return 'No signed message';
    }
    await _connectWallet(
      signedMessage: signMessageResult.signatures.first,
      publicKey: signer,
      apiUrl: envState.apiUrl,
      jwtToken: envState.jwtToken ?? '',
    );
    ref.invalidate(registerWalletToSocketEvents);
    ref.read(registerWalletToSocketEvents);
    return 'OK';
  }

  Future<dynamic> authorizeIfNeededWithOnComplete({
    String? overrideCluster,
    Function()? onStart,
    Future Function(
      MobileWalletAdapterClient client,
      LocalAssociationScenario session,
    )? onComplete,
  }) async {
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

    String? walletAddress = ref.read(environmentProvider).publicKey?.toBase58();
    if (walletAddress != null) {
      try {
        return onComplete != null
            ? await onComplete(await session.start(), session)
            : 'OK';
      } catch (exception) {
        await session.close();
        rethrow;
      }
    }

    // final wallets = await ref.read(
    //   userWalletsProvider(id: ref.read(environmentProvider).user?.id).future,
    // );
    final client = await session.start();
    final result = await _authorizeAndSignIfNeeded(
      client: client,
      shouldSignMessage: true, // until figure out
    );

    if (result != 'OK') {
      await session.close();
      return result;
    }

    if (onStart != null) {
      onStart();
    }
    try {
      if (onComplete != null) {
        return await onComplete(client, session);
      }
      await session.close();
      return 'OK';
    } catch (exception) {
      await session.close();
      rethrow;
    }
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
    } catch (exception) {
      throw Exception(exception);
    }
  }

  Future<dynamic> mint(String? candyMachineAddress, String? label) async {
    if (candyMachineAddress == null) {
      return 'Candy machine not found.';
    }
    try {
      ref.read(globalStateProvider.notifier).state.copyWith(isLoading: true);
      return await authorizeIfNeededWithOnComplete(
        onComplete: (
          MobileWalletAdapterClient client,
          LocalAssociationScenario session,
        ) async {
          if (await _doReauthorize(client)) {
            final walletAddress =
                ref.read(environmentProvider).publicKey?.toBase58();
            if (walletAddress == null) {
              await session.close();
              return 'Missing wallet';
            }
            final isWalletEligibleForMint = await _isWalletEligibleForMint(
              candyMachineAddress: candyMachineAddress,
              walletAddress: walletAddress,
            );
            if (!isWalletEligibleForMint) {
              await session.close();
              return 'Wallet address ${Formatter.formatAddress(walletAddress, 3)} is not eligible for minting';
            }

            final List<dynamic> encodedNftTransactions = await ref
                .read(transactionRepositoryProvider)
                .mintOneTransaction(
                  candyMachineAddress: candyMachineAddress,
                  minterAddress: walletAddress,
                  label: label,
                );
            if (encodedNftTransactions.isEmpty) {
              await session.close();
              return false;
            }
            return _signAndSendMint(
              encodedNftTransactions: encodedNftTransactions,
              client: client,
              session: session,
            );
          }
          await session.close();
          return false;
        },
      );
    } catch (exception) {
      Sentry.captureException(
        exception is BadRequestException ? exception.cause : exception,
        stackTrace:
            'authorizeIfNeededWithOnComplete: ${ref.read(environmentProvider).user?.email}',
      );
      rethrow;
    }
  }

  Future<dynamic> _signAndSendMint({
    required List encodedNftTransactions,
    required MobileWalletAdapterClient client,
    required LocalAssociationScenario session,
  }) async {
    try {
      final response = await client.signTransactions(
        transactions: encodedNftTransactions.map((transaction) {
          return base64Decode(transaction);
        }).toList(),
      );
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
        await session.close();
        return true;
      }
    } catch (exception) {
      await session.close();
      Sentry.captureException(
        exception,
        stackTrace:
            'User with ${ref.read(environmentProvider).user?.email} failed to sign and send mint.',
      );
      if (exception is JsonRpcException) {
        return exception.message;
      }
      await session.close();
      return false;
    }
  }

  Future<dynamic> list({
    required String sellerAddress,
    required String mintAccount,
    required int price,
    String printReceipt = 'false',
  }) async {
    try {
      return await authorizeIfNeededWithOnComplete(
        onComplete: (client, session) async {
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
          return await _signAndSendTransactions(
            client: client,
            session: session,
            encodedTransactions: [encodedTransaction],
          );
        },
      );
    } catch (exception) {
      if (exception is LowPowerModeException ||
          exception is NoWalletFoundException) {
        rethrow;
      }
      Sentry.captureException(exception,
          stackTrace:
              'List failed. Seller $sellerAddress, mintAccount $mintAccount - user with ${ref.read(environmentProvider).user?.email}');
      return false;
    }
  }

  Future<dynamic> delist({
    required String nftAddress,
  }) async {
    try {
      return await authorizeIfNeededWithOnComplete(
        onComplete: (client, session) async {
          final String? encodedTransaction = await ref
              .read(transactionRepositoryProvider)
              .cancelListingTransaction(nftAddress: nftAddress);
          if (encodedTransaction == null) {
            return false;
          }
          return await _signAndSendTransactions(
            client: client,
            session: session,
            encodedTransactions: [encodedTransaction],
          );
        },
      );
    } catch (exception) {
      if (exception is LowPowerModeException ||
          exception is NoWalletFoundException) {
        rethrow;
      }
      Sentry.captureException(exception,
          stackTrace:
              'Delist failed for ${ref.read(environmentProvider).user?.email}.');
      return false;
    }
  }

  Future<bool> buyMultiple(List<BuyNftInput> input) async {
    try {
      return await authorizeIfNeededWithOnComplete(
        onComplete: (client, session) async {
          Map<String, String> query = {};
          for (int i = 0; i < input.length; ++i) {
            query["instantBuyParams[$i]"] = jsonEncode(input[i].toJson());
          }
          final List<String> encodedTransactions = await ref
              .read(transactionRepositoryProvider)
              .buyMultipleItems(query);
          if (encodedTransactions.isEmpty) {
            return false;
          }
          return await _signAndSendTransactions(
            client: client,
            session: session,
            encodedTransactions: encodedTransactions,
          );
        },
      );
    } catch (exception) {
      if (exception is LowPowerModeException ||
          exception is NoWalletFoundException) {
        rethrow;
      }
      Sentry.captureException(exception,
          stackTrace:
              'Buy multiple failed for ${ref.read(environmentProvider).user?.email}');
      return false;
    }
  }

  Future<dynamic> useMint({
    required String nftAddress,
    required String ownerAddress,
  }) async {
    try {
      return await authorizeIfNeededWithOnComplete(
        onComplete: (client, session) async {
          final String transaction = await ref
              .read(transactionRepositoryProvider)
              .useComicIssueNftTransaction(
                nftAddress: nftAddress,
                ownerAddress: ownerAddress,
              );
          return await _signAndSendTransactions(
            client: client,
            session: session,
            encodedTransactions: [transaction],
          );
        },
      );
    } catch (exception) {
      if (exception is LowPowerModeException ||
          exception is NoWalletFoundException) {
        rethrow;
      }
      Sentry.captureException(exception,
          stackTrace:
              'Failed to use mint: nftAddress $nftAddress, owner: $ownerAddress. User: ${ref.read(environmentProvider).user?.email}');
      return false;
    }
  }

  Future<dynamic> _signAndSendTransactions({
    required MobileWalletAdapterClient client,
    required LocalAssociationScenario session,
    required List<String> encodedTransactions,
  }) async {
    ref.read(globalStateProvider.notifier).state.copyWith(isLoading: true);

    if (await _doReauthorize(client)) {
      try {
        final response = await client.signTransactions(
          transactions: encodedTransactions.map((transaction) {
            return base64Decode(transaction);
          }).toList(),
        );
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
          await session.close();
          return true;
        }
      } catch (exception) {
        await session.close();
        Sentry.captureException(exception,
            stackTrace:
                'sign and send transaction: ${ref.read(environmentProvider).user?.email}');
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
      if (message is AppException) {
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

  Future<bool> _authorizeAndStore({
    required MobileWalletAdapterClient client,
  }) async {
    final envState = ref.read(environmentProvider);
    final result = await _authorize(
      client: client,
      cluster: envState.solanaCluster,
    );

    if (result == null) {
      return false;
    }
    final currentWalletAddress =
        Ed25519HDPublicKey(result.publicKey).toBase58();
    final walletsMap = envState.wallets;
    ref.read(selectedWalletProvider.notifier).update(
          (state) => currentWalletAddress,
        );
    ref.read(environmentProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            authToken: result.authToken,
            wallets: {
              ...?walletsMap,
              currentWalletAddress: WalletData(
                authToken: result.authToken,
              ),
            },
          ),
        );
    ref.invalidate(registerWalletToSocketEvents);
    ref.read(registerWalletToSocketEvents);
    return true;
  }

  Future<bool> _doReauthorize(MobileWalletAdapterClient client,
      [String? overrideAuthToken, String? overrideSigner]) async {
    final envState = ref.read(environmentProvider);
    String? currentWalletAddress =
        overrideSigner ?? envState.publicKey?.toBase58();

    if (currentWalletAddress == null) {
      return await _authorizeAndStore(client: client);
    }
    final walletAuthToken = envState.wallets?[currentWalletAddress]?.authToken;

    final authToken = overrideAuthToken ??
        walletAuthToken ??
        ref.read(environmentProvider).authToken;
    if (authToken == null) {
      return await _authorizeAndStore(client: client);
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
    if (result == null) {
      return false;
    }
    final publicKey = Ed25519HDPublicKey(result.publicKey);
    final address = publicKey.toBase58();
    final walletsMap = envState.wallets;
    ref.read(selectedWalletProvider.notifier).update(
          (state) => address,
        );
    ref.read(environmentProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            authToken: result.authToken,
            publicKey: publicKey,
            wallets: {
              ...?walletsMap,
              address: WalletData(
                authToken: result.authToken,
              ),
            },
          ),
        );
    ref.invalidate(registerWalletToSocketEvents);
    ref.read(registerWalletToSocketEvents);
    return true;
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
    ref.read(isOpeningSessionProvider.notifier).update((state) => true);
    final session = await LocalAssociationScenario.create();
    session.startActivityForResult(null).ignore();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        ref.read(isOpeningSessionProvider.notifier).update((state) => false);
      },
    );
    return session;
  }

  Future<bool> _isWalletEligibleForMint({
    required String candyMachineAddress,
    required String walletAddress,
  }) async {
    final candyMachineState = ref.read(candyMachineStateProvider);
    var activeGroup = getActiveGroup(candyMachineState?.groups ?? []);

    if (activeGroup == null || activeGroup.wallet?.supply == null) {
      final candyMachine = await ref.read(candyMachineProvider(
        query:
            'candyMachineAddress=$candyMachineAddress&walletAddress=$walletAddress',
      ).future);
      activeGroup = getActiveGroup(candyMachine?.groups ?? []);
      if (activeGroup == null) {
        return false;
      }
      return activeGroup.wallet != null && activeGroup.wallet!.isEligible;
    }
    return activeGroup.wallet != null && activeGroup.wallet!.isEligible;
  }
}
