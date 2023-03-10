import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/repositories/wallet/repository_impl.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';

final walletAssetsProvider = FutureProvider((_) {
  return IoCContainer.resolveContainer<WalletRepositoryImpl>().myAssets();
});

final myWalletProvider = FutureProvider((_) {
  return IoCContainer.resolveContainer<WalletRepositoryImpl>().myWallet();
});

class UpdateAvatarPayload {
  final String address;
  final MultipartFile avatar;

  UpdateAvatarPayload({
    required this.address,
    required this.avatar,
  });
}

final updateWalletAvatarProvider =
    FutureProvider.family<WalletModel?, UpdateAvatarPayload>(
  (ref, payload) {
    return IoCContainer.resolveContainer<WalletRepositoryImpl>()
        .updateAvatar(payload);
  },
);
