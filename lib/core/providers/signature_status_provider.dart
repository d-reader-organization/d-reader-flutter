import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/solana.dart';

final mintingStatusProvider = StateProvider.family<void, String>(
  (ref, signature) {
    if (signature.isNotEmpty) {
      final client = createSolanaClient(
          rpcUrl: ref.read(environmentProvider).solanaCluster ==
                  SolanaCluster.devnet.value
              ? Config.rpcUrlDevnet
              : Config.rpcUrlMainnet);
      client
          .waitForSignatureStatus(
        signature,
        status: Commitment.finalized,
        timeout: const Duration(seconds: 30),
      )
          .then((value) {
        Future.delayed(const Duration(milliseconds: 2500), () {
          ref.read(globalStateProvider.notifier).update(
                (state) => state.copyWith(
                  isLoading: false,
                  isMinting: false,
                ),
              );
        });
      }).onError((error, stackTrace) {
        Sentry.captureException(error, stackTrace: stackTrace);
        ref.read(globalStateProvider.notifier).update(
              (state) => state.copyWith(
                isLoading: false,
                isMinting: null,
              ),
            );
      });
    }
  },
);
