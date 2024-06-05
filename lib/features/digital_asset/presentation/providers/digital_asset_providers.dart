import 'dart:async' show TimeoutException, Timer;

import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/digital_asset/domain/models/digital_asset.dart';
import 'package:d_reader_flutter/features/digital_asset/domain/providers/digital_asset_provider.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/domain/providers/solana/solana_providers.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/solana.dart';

final digitalAssetProvider = FutureProvider.autoDispose
    .family<DigitalAssetModel?, String>((ref, address) async {
  final response =
      await ref.read(digitalAssetRepositoryProvider).getDigitalAsset(address);

  return response.fold((exception) {
    return null;
  }, (digitalAsset) => digitalAsset);
});

final digitalAssetsProvider =
    FutureProvider.family<List<DigitalAssetModel>, String>((ref, query) async {
  Timer? timer;

  ref.onDispose(() {
    timer?.cancel();
  });

  ref.onCancel(() {
    timer = Timer(const Duration(seconds: paginatedDataCacheInSeconds), () {
      ref.invalidateSelf();
    });
  });

  ref.onResume(() {
    timer?.cancel();
  });
  final response =
      await ref.read(digitalAssetRepositoryProvider).getDigitalAssets(query);
  return response.fold((exception) => [], (digitalAssets) => digitalAssets);
});

final lastProcessedAssetProvider = StateProvider<String?>(
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
    final client = ref.read(solanaClientProvider);

    client
        .waitForSignatureStatus(
      signature,
      status: Commitment.confirmed,
      timeout: const Duration(seconds: chainStatusTimeoutInSeconds),
    )
        .then((value) {
      const timeToWaitForSocketEventInSeconds = 7;
      Future.delayed(
        const Duration(
          seconds: timeToWaitForSocketEventInSeconds,
        ),
        () {
          ref.read(globalNotifierProvider.notifier).update(
                isLoading: false,
                newMessage: TransactionStatusMessage.success.getString(),
              );
        },
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
      const Duration(seconds: chainStatusTimeoutInSeconds),
      onTimeout: () {
        ref.read(globalNotifierProvider.notifier).update(
              isLoading: false,
              newMessage: TransactionStatusMessage.timeout.getString(),
            );
      },
    );
  },
);
