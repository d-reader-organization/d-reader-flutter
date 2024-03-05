import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/features/nft/presentations/providers/nft_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/solana.dart' show lamportsPerSol;

part 'nft_controller.g.dart';

@riverpod
class NftController extends _$NftController {
  @override
  void build() {}

  Future<void> delist({
    required NftModel nft,
    required void Function() callback,
    required void Function(Object exception) onException,
  }) async {
    try {
      final result = await ref
          .read(solanaProvider.notifier)
          .delist(nftAddress: nft.address);
      // globalNotifier.update((state) => state.copyWith(isLoading: false));

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
      // globalNotifier.update((state) => state.copyWith(isLoading: false));
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
      // globalNotifier.update((state) => state.copyWith(isLoading: false));

      await Future.delayed(
        const Duration(milliseconds: 500),
        () {
          callback(response);
          ref.invalidate(nftProvider);
        },
      );
    } catch (exception) {
      // globalNotifier.update((state) => state.copyWith(isLoading: false));
      rethrow;
    }
  }
}
