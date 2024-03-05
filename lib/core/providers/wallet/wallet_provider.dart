import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/providers/candy_machine_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/dio/dio_provider.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/core/repositories/wallet/repository_impl.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/receipt.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/wallet.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/socket_provider.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/dto.dart';
part 'wallet_provider.g.dart';

final walletNameProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

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
    if (address.isEmpty) {
      return;
    }
    socket.on('wallet/$address/item-used', (data) {
      ref.invalidate(ownedIssuesProvider);
      ref.invalidate(nftProvider);
      return ref
          .read(lastProcessedNftProvider.notifier)
          .update((state) => data['address']);
    });
    socket.on('wallet/$address/item-minted', (data) async {
      final newReceipt = Receipt.fromJson(data);
      ref.invalidate(candyMachineProvider);
      ref
          .read(lastProcessedNftProvider.notifier)
          .update((state) => newReceipt.nft.address);
      ref.invalidate(comicIssueDetailsProvider);
    });
  },
);

@riverpod
Future<WalletModel?> getWallet(
  Ref ref, {
  required String address,
}) {
  return ref.read(walletRepositoryProvider).getWallet(address);
}

final syncWalletProvider = FutureProvider.autoDispose.family<dynamic, String>(
  (ref, walletAddress) {
    return ref.read(walletRepositoryProvider).syncWallet(walletAddress);
  },
);

@riverpod
Future<AccountResult> accountInfo(
  AccountInfoRef ref, {
  required String address,
}) {
  final client = createSolanaClient(
    rpcUrl: ref.read(environmentProvider).solanaCluster ==
            SolanaCluster.devnet.value
        ? Config.rpcUrlDevnet
        : Config.rpcUrlMainnet,
  );
  return client.rpcClient.getAccountInfo(address);
}

final selectedWalletProvider = StateProvider.autoDispose<String>(
  (ref) {
    final latestWallet =
        ref.read(environmentProvider).publicKey?.toBase58() ?? '';
    return latestWallet;
  },
);

@riverpod
Future<bool> isWalletAvailable(Ref ref) {
  return isWalletAppAvailable();
}
