import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/dio_provider.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/core/providers/socket_client_provider.dart';
import 'package:d_reader_flutter/core/repositories/wallet/repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final walletRepositoryProvider = Provider<WalletRepositoryImpl>(
  (ref) {
    return WalletRepositoryImpl(
      client: ref.watch(dioProvider),
    );
  },
);

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

    socket.connect();
    final String address =
        ref.read(environmentProvider).publicKey?.toBase58() ?? '';

    socket.on('wallet/$address/item-used', (data) {
      ref.invalidate(ownedIssuesProvider);
      ref.invalidate(nftProvider);
      return ref
          .read(lastProcessedNftProvider.notifier)
          .update((state) => data['address']);
    });
  },
);

final syncWalletProvider = FutureProvider.autoDispose.family<dynamic, String>(
  (ref, walletAddress) {
    return ref.read(walletRepositoryProvider).syncWallet(walletAddress);
  },
);
