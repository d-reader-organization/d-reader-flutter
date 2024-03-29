import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/nft/presentation/providers/nft_providers.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/receipt.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/socket_provider.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';

part 'wallet_providers.g.dart';

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

@riverpod
Future<bool> isWalletAvailable(Ref ref) {
  return isWalletAppAvailable();
}

final selectedWalletProvider = StateProvider.autoDispose<String>(
  (ref) {
    final latestWallet =
        ref.read(environmentProvider).publicKey?.toBase58() ?? '';
    return latestWallet;
  },
);
final walletNameProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

final chainSubscriptionClientProvider =
    StreamProvider.family.autoDispose<Account?, String>((
  ref,
  address,
) async* {
  final currentAccountData =
      await ref.read(accountInfoProvider(address: address).future);
  final subscriptionClient = SubscriptionClient.connect(
      ref.read(environmentProvider).solanaCluster == SolanaCluster.devnet.value
          ? Config.rpcUrlDevnet.replaceAll(
              'https',
              'ws',
            )
          : Config.rpcUrlMainnet.replaceAll(
              'https',
              'ws',
            ));
  try {
    Account? accountData = currentAccountData.value;
    subscriptionClient
        .accountSubscribe(
      address,
    )
        .listen((event) {
      accountData = event;
    });
    yield accountData;
  } catch (error) {
    throw Exception(error);
  }
});
