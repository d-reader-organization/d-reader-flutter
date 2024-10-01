import 'dart:convert';
import 'dart:typed_data';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/authentication/domain/providers/auth_provider.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/features/user/presentation/providers/user_providers.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/wallet.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/solana_providers.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/shared/utils/extensions.dart';
import 'package:power/power.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/base58.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

part 'mwa_notifier.g.dart';

@riverpod
class MwaNotifier extends _$MwaNotifier {
  @override
  void build() {}

  Future<AuthorizationResult?> _authorize({
    required MobileWalletAdapterClient client,
    required String cluster,
  }) {
    return client.authorize(
      identityUri: Uri.parse(Config.dReaderIdentityUrl),
      identityName: Config.dReaderIdentityName,
      cluster: cluster,
      iconUri: Uri.file(Config.faviconPath),
    );
  }

  Future<bool> doReauthorize(MobileWalletAdapterClient client,
      [String? overrideAuthToken, String? overrideSigner]) async {
    final envState = ref.read(environmentProvider);
    String? currentWalletAddress =
        overrideSigner ?? envState.publicKey?.toBase58();

    if (currentWalletAddress == null) {
      return await _authorizeAndStore(client: client);
    }
    final walletAuthToken = envState.walletAuthTokenMap?[currentWalletAddress];

    final authToken = overrideAuthToken ??
        walletAuthToken ??
        ref.read(environmentProvider).authToken;
    if (authToken == null) {
      return await _authorizeAndStore(client: client);
    }
    var result = await client.reauthorize(
      identityUri: Uri.parse(Config.dReaderIdentityUrl),
      identityName: Config.dReaderIdentityName,
      authToken: authToken,
      iconUri: Uri.file(Config.faviconPath),
    );
    result ??= await client.authorize(
      identityUri: Uri.parse(Config.dReaderIdentityUrl),
      identityName: Config.dReaderIdentityName,
      cluster: envState.solanaCluster,
      iconUri: Uri.file(Config.faviconPath),
    );
    if (result == null) {
      return false;
    }
    final publicKey = Ed25519HDPublicKey(result.publicKey);
    final address = publicKey.toBase58();
    final walletsMap = envState.walletAuthTokenMap;
    ref.read(environmentProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            authToken: result.authToken,
            publicKey: publicKey,
            walletAuthTokenMap: {
              ...?walletsMap,
              address: result.authToken,
            },
          ),
        );
    ref.invalidate(registerWalletToSocketEvents);
    ref.read(registerWalletToSocketEvents);
    return true;
  }

  Future<Either<String, SignedMessage>> _signMessage({
    required MobileWalletAdapterClient client,
    required Ed25519HDPublicKey signer,
    required String overrideAuthToken,
    required String apiUrl,
  }) async {
    if (await doReauthorize(client, overrideAuthToken, signer.toBase58())) {
      final response =
          await ref.read(authRepositoryProvider).getOneTimePassword(
                address: signer.toBase58(),
              );
      return response.fold((failure) {
        return const Left('Failed to sign message');
      }, (oneTimePassword) async {
        final addresses = Uint8List.fromList(signer.bytes);

        final messageToBeSigned =
            Uint8List.fromList(utf8.encode(oneTimePassword));
        try {
          final result = await client.signMessages(
            messages: [messageToBeSigned],
            addresses: [addresses],
          );
          return Right(result.signedMessages.first);
        } catch (exception, stackTrace) {
          Sentry.captureException(exception, stackTrace: stackTrace);
          return Left(exception.toString());
        }
      });
    }
    return const Left('Failed to do reauthorize');
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
    final publicKey = Ed25519HDPublicKey(result.publicKey);
    final currentWalletAddress = publicKey.toBase58();
    final walletsMap = envState.walletAuthTokenMap;

    ref.read(environmentProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            authToken: result.authToken,
            publicKey: publicKey,
            walletAuthTokenMap: {
              ...?walletsMap,
              currentWalletAddress: result.authToken,
            },
          ),
        );
    ref.invalidate(registerWalletToSocketEvents);
    ref.read(registerWalletToSocketEvents);
    return true;
  }

  Future<Either<AppException, String>> authorizeIfNeededWithOnComplete({
    bool isConnectOnly = false,
    String? overrideCluster,
    Function()? onStart,
    Future<Either<AppException, String>> Function(
      MobileWalletAdapterClient client,
      LocalAssociationScenario session,
    )? onComplete,
  }) async {
    late LocalAssociationScenario session;
    try {
      session = await _getSession();
    } catch (exception) {
      if (exception is AppException) {
        return Left(exception);
      }

      Sentry.captureException(exception);
      return Left(
        AppException(
          message: exception.toString(),
          identifier: 'SolanaNotifier.getSession',
          statusCode: 500,
        ),
      );
    }
    String? walletAddress = ref.read(environmentProvider).publicKey?.toBase58();
    if (!isConnectOnly && walletAddress != null) {
      try {
        if (onComplete != null) {
          return await onComplete(await session.start(), session);
        }
        await session.close();
        return const Right(successResult);
      } catch (exception) {
        await session.close();
        return Left(
          AppException(
            message: exception.toString(),
            identifier: 'SolanaNotifier.onComplete',
            statusCode: 500,
          ),
        );
      }
    }

    final client = await session.start();
    final wallets = await ref.read(
      userWalletsProvider(id: ref.read(environmentProvider).user?.id).future,
    );
    final result = await _authorizeAndSignIfNeeded(
      client: client,
      wallets: wallets,
      shouldSignMessage: isConnectOnly,
    );

    // Invalidate candy machine to refetch eligibility
    if (ref.read(selectedCandyMachineGroup) != null) {
      final signerAddress = ref.read(environmentProvider).publicKey?.toBase58();
      final currentCMAddress = ref.read(candyMachineStateProvider)?.address;
      ref.invalidate(candyMachineProvider);
      await ref.read(candyMachineProvider(
              query:
                  'candyMachineAddress=$currentCMAddress${'&walletAddress=$signerAddress'}')
          .future);
    }

    if (result != successResult) {
      await session.close();
      return Left(
        AppException(
          message: result,
          identifier: 'SolanaNotifier._authorizeAndSignIfNeeded',
          statusCode: 500,
        ),
      );
    }

    if (onStart != null) {
      onStart();
    }
    try {
      if (onComplete != null) {
        return await onComplete(client, session);
      }
      await session.close();
      return const Right(successResult);
    } catch (exception) {
      await session.close();
      return Left(
        AppException(
          message: exception.toString(),
          identifier: 'SolanaNotifier.onComplete',
          statusCode: 500,
        ),
      );
    }
  }

  Future<String> _authorizeAndSignIfNeeded({
    required MobileWalletAdapterClient client,
    required List<WalletModel> wallets,
    bool shouldSignMessage = true,
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
    final currentWallets = ref.read(environmentProvider).walletAuthTokenMap;
    envNotifier.updateEnvironmentState(
      EnvironmentStateUpdateInput(
        publicKey: publicKey,
        authToken: result.authToken,
        solanaCluster: cluster,
        walletAuthTokenMap: {
          ...?currentWallets,
          publicKey.toBase58(): result.authToken,
        },
      ),
    );
    final isExistingWallet = wallets.firstWhereOrNull(
            (element) => element.address == publicKey.toBase58()) !=
        null;
    if (shouldSignMessage || !isExistingWallet) {
      return await _signMessageAndConnectWallet(
        client: client,
        signer: publicKey,
        authToken: result.authToken,
        apiUrl: Config.apiUrl,
      );
    }
    ref.invalidate(registerWalletToSocketEvents);
    ref.read(registerWalletToSocketEvents);
    return successResult;
  }

  Future<String> _signMessageAndConnectWallet({
    required MobileWalletAdapterClient client,
    required final Ed25519HDPublicKey signer,
    required final String authToken,
    required final String apiUrl,
  }) async {
    final signMessageResponse = await _signMessage(
      client: client,
      signer: signer,
      overrideAuthToken: authToken,
      apiUrl: apiUrl,
    );
    return await signMessageResponse.fold((failMessage) {
      return failMessage;
    }, (signedMessage) async {
      final connectWalletResult = await _connectWallet(
        signedMessage: signedMessage.signatures.first,
        publicKey: signer,
      );
      return connectWalletResult.fold((failure) {
        return failure.message;
      }, (message) async {
        ref.invalidate(registerWalletToSocketEvents);
        ref.read(registerWalletToSocketEvents);
        return message;
      });
    });
  }

  Future<Either<AppException, String>> _connectWallet({
    required Uint8List signedMessage,
    required Ed25519HDPublicKey publicKey,
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
          );
      return const Right(successResult);
    } catch (exception) {
      return Left(
        AppException(
          identifier: 'SolanaNotifier._connectWallet',
          message: exception.toString(),
          statusCode: 500,
        ),
      );
    }
  }

  Future<LocalAssociationScenario> _getSession() async {
    final bool isWalletAvailable = await LocalAssociationScenario.isAvailable();
    final bool isLowPowerMode = await Power.isLowPowerMode;
    if (isLowPowerMode) {
      throw LowPowerModeException(message: powerSaveModeText);
    }
    if (!isWalletAvailable) {
      throw NoWalletFoundException(message: missingWalletAppText);
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
}
