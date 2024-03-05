import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/features/nft/presentations/providers/nft_providers.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/receipt.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/socket_provider.dart';
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

final selectedWalletProvider = StateProvider.autoDispose<String>(
  (ref) {
    final latestWallet =
        ref.read(environmentProvider).publicKey?.toBase58() ?? '';
    return latestWallet;
  },
);
