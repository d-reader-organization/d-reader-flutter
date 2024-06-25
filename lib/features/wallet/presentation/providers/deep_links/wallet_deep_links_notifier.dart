import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/authentication/domain/providers/auth_provider.dart';
import 'package:d_reader_flutter/features/transaction/presentation/providers/common/transaction_state.dart';
import 'package:d_reader_flutter/features/user/presentation/providers/user_providers.dart';
import 'package:d_reader_flutter/routing/router.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ios_wallet_connect/ios_wallet_connect.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/solana.dart';

part 'wallet_deep_links_notifier.g.dart';

/* 
conclusion with deeplinks we cant have something like authorizeWithOnComplete wrapper because of redirect link.
for phantom we can return result if we don't care about redirect link

*/

const String _walletApp = 'phantom.app'; // 'solflare.com';

abstract class _RejectResponse {
  final String errorCode, errorMessage;
  _RejectResponse({required this.errorCode, required this.errorMessage});
}

class _ConnectResponse extends _RejectResponse {
  final String publicKeyBase58;
  final String session;

  _ConnectResponse({
    required this.publicKeyBase58,
    required this.session,
    required super.errorCode,
    required super.errorMessage,
  });

  factory _ConnectResponse.fromJson(dynamic json) => _ConnectResponse(
        errorCode: json['errorCode'] ?? '',
        errorMessage: json['errorMessage'] ?? '',
        publicKeyBase58: json['public_key'] ?? '',
        session: json['session'] ?? '',
      );
}

class _SignResponse extends _RejectResponse {
  final String signature;

  _SignResponse({
    required super.errorCode,
    required super.errorMessage,
    required this.signature,
  });

  factory _SignResponse.fromJson(dynamic json) => _SignResponse(
        errorCode: json['errorCode'] ?? '',
        errorMessage: json['errorMessage'] ?? '',
        signature: json['signature'] ?? '',
      );
}

@Riverpod(keepAlive: true)
class WalletDeepLinksNotifier extends _$WalletDeepLinksNotifier {
  late final IosWalletConnect _client;

  @override
  TransactionState build() {
    _client = IosWalletConnect(
      appUrl: Config.dReaderIdentityUrl,
      deepLinkUrl: "dreader:",
    )..init();
    return const TransactionState.initialized();
  }

  Future<void> connect() {
    return _client.connect(
      cluster: SolanaCluster.devnet.value,
      wallet: _walletApp,
      redirect:
          '/${RoutePath.connectWallet}?from=${_currentRoute()}', // /comic-issue/:id
    );
  }

  Future<void> afterConnect(Map<String, String> query) async {
    final data =
        _client.decryptPayload(data: query['data']!, nonce: query['nonce']!);
    final _ConnectResponse(:errorMessage, :publicKeyBase58, :session) =
        _ConnectResponse.fromJson(data);

    if (errorMessage.isNotEmpty) {
      state = TransactionState.failed(errorMessage);
      return;
    }

    if (publicKeyBase58.isEmpty) {
      state = const TransactionState.failed('Failed to get wallet address');
      return;
    }

    ref.read(environmentProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            authToken: session,
            publicKey: Ed25519HDPublicKey.fromBase58(publicKeyBase58),
            walletAuthTokenMap: {
              ...?ref.read(environmentProvider).walletAuthTokenMap,
              publicKeyBase58: session,
            },
          ),
        );

    final isExistingWallet = await _isExistingWallet(publicKeyBase58);
    if (isExistingWallet) {
      state = const TransactionState.success(successResult);
      return;
    }

    await _signMessage(publicKeyBase58, query['from']);
  }

  Future<bool> _isExistingWallet(String address) async {
    final wallets = await ref.read(
      userWalletsProvider(id: ref.read(environmentProvider).user?.id).future,
    );
    return wallets.firstWhereOrNull((element) => element.address == address) !=
        null;
  }

  Future<void> _signMessage(String address, String? from) async {
    final String oneTimePassword = await _getOtp(address);
    await _client.signMessage(
      message: utf8.encode(oneTimePassword),
      wallet: _walletApp,
      redirect: '/${RoutePath.signMessage}?from=${from ?? _currentRoute()}',
    );
  }

  Future<void> afterSignMessage(Map<String, String> query) async {
    final String signedMessage = _getSignature(query);
    await ref.read(authRepositoryProvider).connectWallet(
          address: ref.read(environmentProvider).publicKey?.toBase58() ?? '',
          encoding: signedMessage,
        );

    ref.invalidate(userWalletsProvider);
    state = const TransactionState.success(successResult);
  }

  Future _getOtp(String address) async {
    final authRepo = ref.read(authRepositoryProvider);
    return await authRepo.getOneTimePassword(address: address).then(
      (value) {
        return value.fold(
          (exception) => throw exception,
          (otp) => otp,
        );
      },
    );
  }

  Future<void> signAndSendTransaction(Uint8List transaction) async {
    state = const TransactionState.processing();
    await _client.signAndSendTransaction(
      redirect: '/${RoutePath.transactionLoading}?from=${_currentRoute()}',
      transaction: transaction,
      wallet: _walletApp,
    );
  }

  String _getSignature(Map<String, String> query) {
    final payload =
        _client.decryptPayload(data: query['data']!, nonce: query['nonce']!);
    final _SignResponse(:errorMessage, :signature) =
        _SignResponse.fromJson(payload);

    if (errorMessage.isNotEmpty) {
      state = TransactionState.failed(errorMessage);
      return '';
    }
    return signature;
  }

  void decryptData(Map<String, String> query) {
    if (query['data'] == null || query['nonce'] == null) {
      return;
    }
    final String signature = _getSignature(query);

    state = signature.isNotEmpty
        ? const TransactionState.success(successResult)
        : const TransactionState.failed('Failed to sign and send');
  }

  String _currentRoute() {
    final router = ref.read(routerProvider);
    final routerConfiguration = router.routerDelegate.currentConfiguration;
    return routerConfiguration.last.matchedLocation;
  }
}

// TODO revert
final isIOSProvider = StateProvider<bool>(
  (ref) => true, // defaultTargetPlatform == TargetPlatform.iOS,
);
