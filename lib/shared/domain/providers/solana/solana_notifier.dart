import 'dart:convert';
import 'dart:typed_data';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/authentication/domain/providers/auth_provider.dart';
import 'package:d_reader_flutter/features/authentication/domain/repositories/auth_repository.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:d_reader_flutter/shared/domain/providers/solana/solana_providers.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:power/power.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/base58.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

part 'solana_notifier.g.dart';

@riverpod
class SolanaNotifier extends _$SolanaNotifier {
  late final AuthRepository _authRepository;
  @override
  void build() {
    _authRepository = ref.watch(authRepositoryProvider);
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

  Future<bool> doReauthorize(MobileWalletAdapterClient client,
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

  Future<Either<String, SignedMessage>> _signMessage({
    required MobileWalletAdapterClient client,
    required Ed25519HDPublicKey signer,
    required String overrideAuthToken,
    required String apiUrl,
    required String jwtToken,
  }) async {
    if (await doReauthorize(client, overrideAuthToken, signer.toBase58())) {
      final response = await _authRepository.getOneTimePassword(
        address: signer.toBase58(),
        apiUrl: apiUrl,
        jwtToken: jwtToken,
      );
      return await response.fold((failure) {
        return Left(failure.message);
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

  Future<Either<Exception, String>> authorizeIfNeededWithOnComplete({
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
      if (exception is NoWalletFoundException) {
        return Left(exception);
      } else if (exception is LowPowerModeException) {
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
    if (walletAddress != null) {
      try {
        return onComplete != null
            ? await onComplete(await session.start(), session)
            : const Right('OK');
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
    final result = await _authorizeAndSignIfNeeded(
      client: client,
    );

    if (result != 'OK') {
      await session.close();
      return Right(result);
    }

    if (onStart != null) {
      onStart();
    }
    try {
      if (onComplete != null) {
        return await onComplete(client, session);
      }
      await session.close();
      return const Right('OK');
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
      return await _signMessageAndConnectWallet(
        client: client,
        signer: publicKey,
        authToken: result.authToken,
      );
    }
    ref.invalidate(registerWalletToSocketEvents);
    ref.read(registerWalletToSocketEvents);
    return 'OK';
  }

  Future<dynamic> _signMessageAndConnectWallet({
    required MobileWalletAdapterClient client,
    required final Ed25519HDPublicKey signer,
    required final String authToken,
  }) async {
    final envState = ref.read(environmentProvider);
    final signMessageResponse = await _signMessage(
      client: client,
      signer: signer,
      overrideAuthToken: authToken,
      apiUrl: envState.apiUrl,
      jwtToken: envState.jwtToken ?? '',
    );
    return signMessageResponse.fold((failMessage) {
      return failMessage;
    }, (signedMessage) async {
      final connectWalletResult = await _connectWallet(
        signedMessage: signedMessage.signatures.first,
        publicKey: signer,
        apiUrl: envState.apiUrl,
        jwtToken: envState.jwtToken ?? '',
      );

      return connectWalletResult.fold((failure) {
        return 'Failed to connect wallet to our API';
      }, (message) {
        ref.invalidate(registerWalletToSocketEvents);
        ref.read(registerWalletToSocketEvents);
        return message;
      });
    });
  }

  Future<Either<Exception, String>> _connectWallet({
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
      return const Right('OK');
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
}
