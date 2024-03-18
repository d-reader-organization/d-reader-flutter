import 'dart:async' show Timer;

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/features/nft/domain/providers/nft_provider.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/solana.dart';

final nftProvider =
    FutureProvider.autoDispose.family<NftModel?, String>((ref, address) async {
  final response = await ref.read(nftRepositoryProvider).getNft(address);

  return response.fold((exception) {
    return null;
  }, (nft) => nft);
});

final nftsProvider =
    FutureProvider.family<List<NftModel>, String>((ref, query) async {
  Timer? timer;

  ref.onDispose(() {
    timer?.cancel();
  });

  ref.onCancel(() {
    timer = Timer(const Duration(seconds: 30), () {
      ref.invalidateSelf();
    });
  });

  ref.onResume(() {
    timer?.cancel();
  });
  final response = await ref.read(nftRepositoryProvider).getNfts(query);
  return response.fold((exception) => [], (nfts) => nfts);
});

final lastProcessedNftProvider = StateProvider<String?>(
  (ref) {
    return null;
  },
);

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
          ref.read(globalNotifierProvider.notifier).update(
                isLoading: false,
                isMinting: false,
              );
        });
      }).onError((error, stackTrace) {
        Sentry.captureException(error,
            stackTrace: 'Signature status provider $signature');
        ref.read(globalNotifierProvider.notifier).update(
              isLoading: false,
              isMinting: null,
            );
      });
    }
  },
);
