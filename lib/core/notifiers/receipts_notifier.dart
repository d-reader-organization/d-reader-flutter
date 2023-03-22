import 'package:d_reader_flutter/core/models/receipt.dart';
import 'package:d_reader_flutter/core/notifiers/socket_client_notifier.dart';
import 'package:d_reader_flutter/core/providers/candy_machine_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/solana.dart';

final receiptsAsyncProvider = AsyncNotifierProvider.autoDispose
    .family<ReceiptsAsyncNotifier, List<Receipt>, String>(
        ReceiptsAsyncNotifier.new);

class ReceiptsAsyncNotifier
    extends AutoDisposeFamilyAsyncNotifier<List<Receipt>, String> {
  @override
  FutureOr<List<Receipt>> build(String arg) async {
    final receipts = await ref.read(receiptsProvider(arg).future);
    final socket = ref.read(socketProvider).socket;
    ref.onDispose(() {
      socket.dispose();
    });

    socket.on('candyMachineReceiptCreated', (data) {
      final newReceipt = Receipt.fromJson(data);
      final publicKey = Ed25519HDPublicKey(
          ref.read(solanaProvider).authorizationResult?.publicKey.toList() ??
              []);
      ref.invalidate(comicIssueDetailsProvider);
      ref.invalidate(candyMachineProvider);
      if (newReceipt.buyer.address == publicKey.toBase58()) {
        ref.invalidate(walletAssetsProvider);
      }
      state = AsyncValue.data([newReceipt, ...?state.value]);
    });

    return receipts;
  }
}
