import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solana/solana.dart';

final isOpeningSessionProvider = StateProvider<bool>((ref) {
  return false;
});

final solanaClientProvider = Provider<SolanaClient>((ref) {
  final rpcUrl =
      ref.read(environmentProvider).solanaCluster == SolanaCluster.devnet.value
          ? Config.rpcUrlDevnet
          : Config.rpcUrlMainnet;
  return SolanaClient(
    rpcUrl: Uri.parse(
      rpcUrl,
    ),
    websocketUrl: Uri.parse(
      rpcUrl.replaceAll(
        'https',
        'ws',
      ),
    ),
  );
});
