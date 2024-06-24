import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/features/authentication/domain/providers/auth_provider.dart';
import 'package:d_reader_flutter/features/transaction/presentation/providers/common/transaction_state.dart';
import 'package:d_reader_flutter/features/user/presentation/providers/user_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ios_wallet_connect/ios_wallet_connect.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/solana.dart';

part 'ios_wallet.g.dart';

class _PhantomConnectResponse {
  final String publicKeyBase58;
  final String session;

  _PhantomConnectResponse(
      {required this.publicKeyBase58, required this.session});

  factory _PhantomConnectResponse.fromJson(dynamic json) =>
      _PhantomConnectResponse(
        publicKeyBase58: json['public_key'] ?? '',
        session: json['session'] ?? '',
      );
}

@riverpod
class IosWalletNotifier extends _$IosWalletNotifier {
  late final IosWalletConnect _client;
  @override
  TransactionState build() {
    _client = IosWalletConnect(
      appUrl: Config.dReaderIdentityUrl,
      deepLinkUrl: "dreader:",
    );
    return const TransactionState.initialized();
  }

  /* 
  PHANTOM RESPONSE
  {
    phantom_encryption_public_key: 5qXTovVr6T4NCm76kWQZ95cYSVERkD8GYo97GX2aGUhX, 
    nonce: Bn3ZaETtp68T4eLwpYvzCxWG75uPAVvst, 
    data: XXDeapCvpHVE2URqdoQRdAp4AKk7Gtpj3D1ZjEPCpBdx66cabuUTiZiF3kYznDjXDfvPSzHo9p5AXFvC6uzwpM7kbgLSH3ET9EVuGwpy2mMmyUGB7WXU8Ygz599jEdLrTR9byH8oWyiE1iLZQoAhpqvv5HhxPVBPB1DocKjc1mJuHyrTYaDFwsFVAJMpJCpQ9VtLyxRvzGi8CB8z8BAqgPbF22qTsCbqBHHkpErpu4S6aJRngcTHDAyr62nfS6zXw4rRVGGtxAsUWgnU55p2ka4SVGz4Ft4gGDQJzyew1Zoby4AWNiXro8ate1VhXdVo6JN1gTR32rzaeV4H4dNropaB5fXQv4Pk9sd2cvMmVDJZ546HdGNsMGFwu7VgMu6GySvkjNzZLNxBGLDA2E4jVU78nniugTyBgP,
    public_key: GWv6912hs3cvS39pZAXHAR9QExGkDNMVHujz8PWfcH8N, 
    session: FvMNysU59EkpqfGJQBXJf7v7BgKSwwDYTVAddvXw8aZXF5FTAbMPwnnagYatrpwjFKjt2GTPqQi7NUtUmmPAmVe3yJLiFh55H8XCcUeYLDXoHAjJM1B1hUKZHwBC7cZ4LwtvqSJjRms19LUK8a1qASXgJPskmMuruG8KWKk9MzhACCmzQYo9XRYH6Ljd5uGRkvmEpZM2YcpoBf5GTj5pQaL4
  }
  */

  Future<bool> connect() async {
    await _client.init();

    final result = await _client.connect(
      cluster: SolanaCluster.devnet.value,
    );
    final parsed = _PhantomConnectResponse.fromJson(result);
    final _PhantomConnectResponse(:publicKeyBase58, :session) = parsed;
    if (publicKeyBase58.isEmpty) {
      return false;
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
    final wallets = await ref.read(
      userWalletsProvider(id: ref.read(environmentProvider).user?.id).future,
    );
    final isExistingWallet = wallets.firstWhereOrNull(
            (element) => element.address == publicKeyBase58) !=
        null;
    if (isExistingWallet) {
      return true;
    }
    await _signMessage(publicKeyBase58);

    // emit state Wallet connected or something like that
    return true;
  }

  Future<void> _signMessage(String address) async {
    final String oneTimePassword = await _getOtp(address);
    final signMessageResult = await _client.signMessage(
      message: utf8.encode(oneTimePassword),
    );
    final String signedMessage = signMessageResult?['signature'] ?? '';
    await ref.read(authRepositoryProvider).connectWallet(
          address: address,
          encoding: signedMessage,
        );

    ref.invalidate(userWalletsProvider);
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

  Future<void> signAndSendTransaction() async {
    await _client.signAndSendTransaction(
      transaction: Uint8List.fromList(
        [1, 2, 3, 4, 5],
      ),
    );
  }
}

// TODO revert
final isIOSProvider = StateProvider<bool>(
  (ref) => true, // defaultTargetPlatform == TargetPlatform.iOS,
);
