import 'dart:async' show Timer;

import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/features/nft/domain/providers/nft_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
