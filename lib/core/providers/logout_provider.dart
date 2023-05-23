import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/tab_bar_provider.dart';
import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final logoutProvider = FutureProvider.autoDispose((ref) async {
  final currentNetwork = ref.read(environmentProvider).solanaCluster;
  ref.invalidate(scaffoldProvider);
  ref.invalidate(environmentProvider);
  ref.invalidate(tabBarProvider);
  await Future.wait([
    LocalStore.instance.delete(
      'last-network',
    ),
    LocalStore.instance.delete(Config.hasSeenInitialKey),
  ]);
  await Future.wait(
    [
      ref.read(solanaProvider.notifier).deauthorize(),
      ref
          .read(environmentProvider.notifier)
          .clearDataFromLocalStore(currentNetwork)
    ],
  );
});
