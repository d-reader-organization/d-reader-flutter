import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/receipt.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/socket_client_provider.dart';
import 'package:d_reader_flutter/core/providers/candy_machine_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final receiptsAsyncProvider = AsyncNotifierProvider.autoDispose
    .family<ReceiptsAsyncNotifier, List<Receipt>, ComicIssueModel>(
  ReceiptsAsyncNotifier.new,
);

class ReceiptsAsyncNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Receipt>, ComicIssueModel> {
  @override
  FutureOr<List<Receipt>> build(ComicIssueModel arg) async {
    final receipts =
        await ref.read(receiptsProvider(arg.candyMachineAddress ?? '').future);
    final socket = ref.read(socketProvider).socket;
    socket.connect();
    ref.onDispose(() {
      socket.close();
    });

    socket.on('comic-issue/${arg.id}/item-minted', (data) {
      if (ref.read(environmentProvider).publicKey == null) {
        return;
      }
      final newReceipt = Receipt.fromJson(data);
      final publicKey = ref.read(environmentProvider).publicKey!;
      if (newReceipt.buyer.address == publicKey.toBase58()) {
        ref.invalidate(walletAssetsProvider);
      }

      ref.invalidate(comicIssueDetailsProvider);
      ref.invalidate(candyMachineProvider);
      state = AsyncValue.data([newReceipt, ...?state.value]);
    });

    return receipts;
  }
}
