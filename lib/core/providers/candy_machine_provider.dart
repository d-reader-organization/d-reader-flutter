import 'package:d_reader_flutter/core/models/candy_machine.dart';
import 'package:d_reader_flutter/core/models/receipt.dart';
import 'package:d_reader_flutter/core/notifiers/socket_client_notifier.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:d_reader_flutter/core/repositories/candy_machine/repository_implementation.dart';
import 'package:d_reader_flutter/ioc.dart';
import 'package:d_reader_flutter/ui/utils/append_default_query_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solana/solana.dart';

final candyMachineProvider =
    FutureProvider.family<CandyMachineModel?, String>((ref, address) async {
  return await IoCContainer.resolveContainer<CandyMachineRepositoryImpl>()
      .getCandyMachine(address);
});

final receiptsProvider =
    FutureProvider.family<List<Receipt>, String>((ref, address) async {
  return await IoCContainer.resolveContainer<CandyMachineRepositoryImpl>()
      .getReceipts(
          queryString: appendDefaultQuery('candyMachineAddress=$address'));
});

final mintedItemsProvider = StreamProvider.family<List<Receipt>, String>(
    (ref, candyMachineAddress) async* {
  final socket = ref.read(socketProvider).socket;
  var mintedItems =
      await ref.read(receiptsProvider(candyMachineAddress).future);

  ref.onDispose(() {
    socket.dispose();
  });

  socket.on('candyMachineReceiptCreated', (data) sync* {
    final newReceipt = Receipt.fromJson(data);
    mintedItems = [newReceipt, ...mintedItems];

    final publicKey = Ed25519HDPublicKey(
        ref.read(solanaProvider).authorizationResult?.publicKey.toList() ?? []);
    if (newReceipt.buyer.address == publicKey.toBase58()) {
      ref.invalidate(comicIssueDetailsProvider);
      ref.invalidate(walletAssetsProvider);
    }
    yield mintedItems;
  });

  yield mintedItems;
});
