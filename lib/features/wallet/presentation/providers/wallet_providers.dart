import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/asset_event.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/providers/digital_asset_providers.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/shared/data/remote/socket_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/solana_providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

part 'wallet_providers.g.dart';

final registerWalletToSocketEvents = Provider.autoDispose(
  (ref) {
    final String address =
        ref.watch(environmentProvider).publicKey?.toBase58() ?? '';
    if (address.isEmpty) {
      return;
    }

    final socket = SocketIOService(Config.apiUrl, address);
    ref.onDispose(() {
      socket.emit(leaveRoomEvent, {'walletAddress': address});
    });

    socket.emit(joinRoomEvent, {'walletAddress': address});

    socket.on('wallet/$address/item-used', (data) {
      ref.invalidate(ownedIssuesProvider);
      ref.invalidate(digitalAssetProvider);
      return ref
          .read(lastProcessedAssetProvider.notifier)
          .update((state) => data['address']);
    });
    socket.on('wallet/$address/item-minted', (data) async {
      final AsssetMintedDataModel(:assets) =
          AsssetMintedDataModel.fromJson(data);
      final mintedAsset = assets.first;
      ref.invalidate(candyMachineProvider);
      ref
          .read(lastProcessedAssetProvider.notifier)
          .update((state) => mintedAsset.address);
      ref.invalidate(comicIssueDetailsProvider);
    });
  },
);

@riverpod
Future<AccountResult> accountInfo(
  AccountInfoRef ref, {
  required String address,
}) {
  final client = ref.read(solanaClientProvider);
  return client.rpcClient.getAccountInfo(address);
}

@riverpod
Future<bool> isWalletAvailable(Ref ref) =>
    LocalAssociationScenario.isAvailable();

final selectedWalletProvider = StateProvider.autoDispose<String>(
  (ref) {
    return ref.watch(environmentProvider).publicKey?.toBase58() ?? '';
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
