import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/receipt.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/socket_client_provider.dart';
import 'package:d_reader_flutter/core/providers/candy_machine_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final receiptsAsyncProvider = AsyncNotifierProvider.autoDispose
    .family<ReceiptsAsyncNotifier, List<Receipt>, ComicIssueModel>(
  ReceiptsAsyncNotifier.new,
);

class ReceiptsAsyncNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Receipt>, ComicIssueModel> {
  bool isEnd = false;
  bool isLoading = false;
  @override
  FutureOr<List<Receipt>> build(ComicIssueModel arg) async {
    final receipts = await ref.read(
      receiptsProvider(ReceiptsProviderArg(
        address: arg.candyMachineAddress ?? '',
      )).future,
    );
    final socket = ref
        .read(
          socketProvider(
            ref.read(environmentProvider).apiUrl,
          ),
        )
        .socket;
    socket.connect();
    ref.onDispose(() {
      socket.close();
    });

    socket.on('comic-issue/${arg.id}/item-minted', (data) {
      final newReceipt = Receipt.fromJson(data);
      ref.invalidate(candyMachineProvider);
      state = AsyncValue.data([newReceipt, ...?state.value]);
    });

    return receipts;
  }

  fetchNext() async {
    if (isEnd || isLoading) {
      return;
    }
    isLoading = true;
    final newReceipts = await ref.read(
      receiptsProvider(
        ReceiptsProviderArg(
          address: arg.candyMachineAddress ?? '',
          query: 'skip=${state.value?.length}&take=10',
        ),
      ).future,
    );
    if (newReceipts.isEmpty) {
      isEnd = true;
      return;
    }
    isLoading = false;
    state = AsyncValue.data([...?state.value, ...newReceipts]);
  }
}
