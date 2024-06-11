import 'dart:convert';

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/features/authentication/domain/providers/auth_provider.dart';
import 'package:d_reader_flutter/features/user/presentation/providers/user_providers.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/local_wallet/local_wallet.dart';
import 'package:d_reader_flutter/features/wallet/domain/utils/utils.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/data/local/secure_store.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:solana/base58.dart';

part 'local_wallet_notifier.g.dart';

final _mnemonicKey = Config.mnemonicKey;

abstract class _LocalWalletInterface {
  Future<LocalWallet> createWallet();
  Future<void> deleteWallet();
}

@Riverpod(keepAlive: true)
class LocalWalletNotifier extends _$LocalWalletNotifier
    implements _LocalWalletInterface {
  late final FlutterSecureStorage _storage;

  @override
  Future<LocalWallet?> build() async {
    _storage = ref.read(secureStorageProvider);
    final existingPhrase = await _storage.read(key: _mnemonicKey) ?? '';

    if (existingPhrase.isNotEmpty) {
      final LocalWallet wallet =
          await createLocalWallet(mnemonic: existingPhrase);
      return wallet;
    }
    return null;
  }

  @override
  Future<LocalWallet> createWallet() async {
    state = const AsyncValue.loading();
    final String mnemonic = bip39.generateMnemonic();
    final LocalWallet wallet = await createLocalWallet(mnemonic: mnemonic);
    await Future.wait([
      _storage.write(key: _mnemonicKey, value: mnemonic),
      _connectWalletWAPI(wallet)
    ]);
    state = AsyncValue.data(wallet);
    ref.invalidate(userWalletsProvider);
    ref.read(selectedWalletProvider.notifier).update((state) => wallet.address);
    return wallet;
  }

  @override
  Future<void> deleteWallet() async {
    state = const AsyncValue.loading();
    await ref.read(secureStorageProvider).deleteAll();
    state = const AsyncValue.data(null);
  }

  Future<void> _connectWalletWAPI(LocalWallet wallet) async {
    final oneTimePassword = await _getOTP(wallet.address);
    final encoding = await _getEncodingForConnectWalletWAPI(
      oneTimePassword: oneTimePassword,
      wallet: wallet,
    );
    await ref.read(authRepositoryProvider).connectWallet(
          address: wallet.address,
          encoding: encoding,
        );
  }

  Future<String> _getOTP(String address) async {
    final response = await ref.read(authRepositoryProvider).getOneTimePassword(
          address: address,
        );

    return response.fold(
      (exception) {
        throw AppException(
          message: 'Failed to fetch OTP',
          statusCode: 500,
          identifier: 'Connecting local wallet',
        );
        // handle error;
      },
      (oneTimePassword) => oneTimePassword,
    );
  }

  Future<String> _getEncodingForConnectWalletWAPI({
    required String oneTimePassword,
    required LocalWallet wallet,
  }) async {
    final result = await wallet.sign([utf8.encode(oneTimePassword)]);
    final signedMessage = result.first.bytes;
    return base58encode(
      signedMessage.sublist(
        signedMessage.length - 64,
        signedMessage.length,
      ),
    );
  }
}
