import 'dart:async' show TimeoutException, Timer;

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/features/nft/domain/providers/nft_provider.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
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

final transactionChainStatusProvider = StateProvider.family<void, String>(
  (ref, signature) {
    if (signature.isEmpty) {
      ref.read(globalNotifierProvider.notifier).update(
            isLoading: false,
            newMessage: '',
          );
      return;
    }
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
      timeout: const Duration(seconds: 12),
    )
        .then((value) {
      ref.read(globalNotifierProvider.notifier).update(
            isLoading: false,
            newMessage: TransactionStatusMessage.success.getString(),
          );
    }).onError((exception, stackTrace) {
      if (exception is TimeoutException || exception is RpcTimeoutException) {
        ref.read(globalNotifierProvider.notifier).update(
              isLoading: false,
              newMessage: TransactionStatusMessage.timeout.getString(),
            );
        return;
      }
      Sentry.captureException(
        exception,
        stackTrace: 'Signature status provider $signature',
      );
      ref.read(globalNotifierProvider.notifier).update(
            isLoading: false,
            newMessage: TransactionStatusMessage.fail.getString(),
          );
    }).timeout(
      const Duration(seconds: 12),
      onTimeout: () {
        ref.read(globalNotifierProvider.notifier).update(
              isLoading: false,
              newMessage: TransactionStatusMessage.timeout.getString(),
            );
      },
    );
  },
);
