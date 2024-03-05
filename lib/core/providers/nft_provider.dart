import 'dart:async' show Timer;

import 'package:d_reader_flutter/core/providers/dio/dio_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/repositories/nft/repository_impl.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/solana.dart' show lamportsPerSol;
part 'nft_provider.g.dart';

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

@riverpod
class NftController extends _$NftController {
  late StateController<GlobalState> globalNotifier;
  @override
  FutureOr<void> build() {
    globalNotifier = ref.read(globalStateProvider.notifier);
  }

  Future<void> delist({
    required NftModel nft,
    required void Function() callback,
    required void Function(Object exception) onException,
  }) async {
    try {
      final result = await ref
          .read(solanaProvider.notifier)
          .delist(nftAddress: nft.address);

      globalNotifier.update((state) => state.copyWith(isLoading: false));

      if (result is bool && result) {
        await Future.delayed(
          const Duration(milliseconds: 500),
          () {
            callback();
            ref.invalidate(nftProvider);
          },
        );
      }
    } catch (exception) {
      globalNotifier.update((state) => state.copyWith(isLoading: false));
      onException(exception);
    }
  }

  Future<void> openNft({
    required NftModel nft,
    required void Function(dynamic result) onOpen,
    required void Function(Object exception) onException,
  }) async {
    try {
      final result = await ref.read(solanaProvider.notifier).useMint(
            nftAddress: nft.address,
            ownerAddress: nft.ownerAddress,
          );
      onOpen(result);
    } catch (exception) {
      onException(exception);
    }
  }

  Future<void> listNft({
    required String sellerAddress,
    required String mintAccount,
    required double price,
    required void Function(dynamic result) callback,
  }) async {
    try {
      final response = await ref.read(solanaProvider.notifier).list(
            sellerAddress: sellerAddress,
            mintAccount: mintAccount,
            price: (price * lamportsPerSol).round(),
          );
      globalNotifier.update((state) => state.copyWith(isLoading: false));

      await Future.delayed(
        const Duration(milliseconds: 500),
        () {
          callback(response);
          ref.invalidate(nftProvider);
        },
      );
    } catch (exception) {
      globalNotifier.update((state) => state.copyWith(isLoading: false));
      rethrow;
    }
  }
}
