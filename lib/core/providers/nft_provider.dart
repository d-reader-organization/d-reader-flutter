import 'dart:async' show Timer;

import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/providers/dio/dio_provider.dart';
import 'package:d_reader_flutter/core/repositories/nft/repository_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final nftRepositoryProvider = Provider<NftRepositoryImpl>(
  (ref) {
    return NftRepositoryImpl(
      client: ref.watch(dioProvider),
    );
  },
);

final nftProvider =
    FutureProvider.autoDispose.family<NftModel?, String>((ref, address) {
  return ref.read(nftRepositoryProvider).getNft(address);
});

final nftsProvider =
    FutureProvider.family<List<NftModel>, String>((ref, query) {
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
  return ref.read(nftRepositoryProvider).getNfts(query);
});

final lastProcessedNftProvider = StateProvider<String?>(
  (ref) {
    return null;
  },
);
