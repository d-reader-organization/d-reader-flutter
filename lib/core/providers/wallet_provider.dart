import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/socket_client_provider.dart';
import 'package:d_reader_flutter/core/repositories/wallet/repository_impl.dart';
import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final registerWalletToSocketEvents = Provider(
  (ref) {
    final socket = ref
        .read(
          socketProvider(
            ref.read(environmentProvider).apiUrl,
          ),
        )
        .socket;
    ref.onDispose(() {
      socket.close();
    });
    if (socket.connected) {
      return;
    }
    final String address =
        ref.read(environmentProvider).publicKey?.toBase58() ?? '';

    socket.on('wallet/$address/item-minted', (data) {
      ref.invalidate(walletAssetsProvider);
    });
    socket.on('wallet/$address/item-listed', (data) {
      ref.invalidate(walletAssetsProvider);
    });
    socket.on('wallet/$address/item-delisted', (data) {
      ref.invalidate(walletAssetsProvider);
    });
    socket.on('wallet/$address/item-bought', (data) {
      ref.invalidate(walletAssetsProvider);
    });
    socket.on('wallet/$address/item-sold', (data) {
      ref.invalidate(walletAssetsProvider);
    });
    socket.on('wallet/$address/item-received', (data) {
      ref.invalidate(walletAssetsProvider);
    });
    socket.on('wallet/$address/item-sent', (data) {
      ref.invalidate(walletAssetsProvider);
    });
  },
);

final walletAssetsProvider = FutureProvider((ref) {
  return IoCContainer.resolveContainer<WalletRepositoryImpl>().myAssets();
});

final myWalletProvider = FutureProvider.autoDispose((ref) async {
  final myWallet =
      await IoCContainer.resolveContainer<WalletRepositoryImpl>().myWallet();
  if (myWallet != null &&
      ref.read(environmentProvider).solanaCluster ==
          SolanaCluster.mainnet.value) {
    LocalStore.instance.put('walletName', myWallet.name);
  }
  return myWallet;
});

final updateWalletAvatarProvider =
    FutureProvider.family<WalletModel?, UpdateWalletPayload>(
  (ref, payload) {
    return IoCContainer.resolveContainer<WalletRepositoryImpl>()
        .updateAvatar(payload);
  },
);

final updateWalletProvider = FutureProvider.autoDispose
    .family<dynamic, UpdateWalletPayload>((ref, payload) {
  return IoCContainer.resolveContainer<WalletRepositoryImpl>()
      .updateWallet(payload);
});

final networkChangeUpdateWallet =
    FutureProvider.autoDispose.family<void, String>(
  (ref, address) async {
    final wallet = await ref.read(myWalletProvider.future);
    final walletName = LocalStore.instance.get('walletName');
    if (wallet != null && wallet.name != address) {
      await ref.read(
        updateWalletProvider(
          UpdateWalletPayload(
            address: address,
            name: walletName,
          ),
        ).future,
      );
    }
  },
);

final syncWalletProvider = FutureProvider.autoDispose(
  (ref) {
    return IoCContainer.resolveContainer<WalletRepositoryImpl>().syncWallet();
  },
);
