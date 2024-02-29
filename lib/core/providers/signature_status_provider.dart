import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/utils/utils.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
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
            : Config.rpcUrlMainnet,
      );

      client
          .waitForSignatureStatus(
        signature,
        status: Commitment.confirmed,
        timeout: const Duration(seconds: 10),
      )
          .then((value) {
        Future.delayed(const Duration(seconds: 7), () {
          ref.read(globalStateProvider.notifier).update(
                (state) => state.copyWith(
                  isLoading: false,
                  isMinting: false,
                ),
              );
        });
      }).onError((error, stackTrace) {
        Sentry.captureException(error,
            stackTrace: 'Signature status provider $signature');
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
