import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/repositories/wallet/repository_impl.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final walletAssetsProvider = FutureProvider((_) {
  return IoCContainer.resolveContainer<WalletRepositoryImpl>().myAssets();
});

final myWalletProvider = FutureProvider((_) {
  return IoCContainer.resolveContainer<WalletRepositoryImpl>().myWallet();
});

final updateWalletAvatarProvider =
    FutureProvider.family<WalletModel?, UpdateWalletPayload>(
  (ref, payload) {
    return IoCContainer.resolveContainer<WalletRepositoryImpl>()
        .updateAvatar(payload);
  },
);

final updateWalletProvider =
    FutureProvider.family<WalletModel?, UpdateWalletPayload>((ref, payload) {
  return IoCContainer.resolveContainer<WalletRepositoryImpl>()
      .updateWallet(payload);
});
