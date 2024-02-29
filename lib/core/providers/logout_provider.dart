import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/core/providers/tab_bar_provider.dart';
import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:d_reader_flutter/routing/router.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final logoutProvider = FutureProvider.autoDispose((ref) async {
  final currentNetwork = ref.read(environmentNotifierProvider).solanaCluster;
  ref.invalidate(scaffoldProvider);
  ref.invalidate(environmentNotifierProvider);
  ref.invalidate(tabBarProvider);
  await Future.wait([
    LocalStore.instance.delete(
      'last-network',
    ),
    LocalStore.instance.delete(Config.hasSeenInitialKey),
    LocalStore.instance.clear(),
  ]);
  await ref
      .read(environmentNotifierProvider.notifier)
      .clearDataFromLocalStore(currentNetwork);
  ref.read(authRouteProvider).logout();
});
