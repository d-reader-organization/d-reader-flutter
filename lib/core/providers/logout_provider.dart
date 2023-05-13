import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/tab_bar_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final logoutProvider = FutureProvider((ref) async {
  ref.invalidate(myWalletProvider);
  await Future.wait(
    [
      ref.read(solanaProvider.notifier).deauthorize(),
      ref.read(environmentProvider.notifier).clearDataFromLocalStore()
    ],
  );
  ref.invalidate(tabBarProvider);
  ref.invalidate(scaffoldProvider);
  ref.invalidate(environmentProvider);
});
