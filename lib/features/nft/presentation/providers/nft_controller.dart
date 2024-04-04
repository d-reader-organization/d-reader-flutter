import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/owned_issues_notifier.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/owned/owned_providers.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/features/nft/presentation/providers/nft_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/solana/solana_transaction_notifier.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:flutter/animation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/solana.dart' show lamportsPerSol;
import 'package:video_player/video_player.dart';

part 'nft_controller.g.dart';

@riverpod
class NftController extends _$NftController {
  @override
  void build() {}

  Future<void> delist({
    required String nftAddress,
    required void Function() callback,
    required void Function(Object exception) onException,
  }) async {
    try {
      final delistResult = await ref
          .read(solanaTransactionNotifierProvider.notifier)
          .delist(nftAddress: nftAddress);

      delistResult.fold((exception) {
        ref.read(privateLoadingProvider.notifier).update((state) => false);
        onException(exception);
      }, (result) async {
        if (result != 'OK') {
          ref.read(privateLoadingProvider.notifier).update((state) => false);
          return onException(
            AppException(
              message: result,
              statusCode: 500,
              identifier: 'nftController.delist',
            ),
          );
        }
        await Future.delayed(
          const Duration(milliseconds: 1200),
          () {
            ref.invalidate(nftProvider);
            ref.read(privateLoadingProvider.notifier).update((state) => false);
            callback();
          },
        );
      });
    } catch (exception) {
      ref.read(privateLoadingProvider.notifier).update((state) => false);
      onException(exception);
    }
  }

  Future<void> openNft({
    required NftModel nft,
    required void Function(String result) onOpen,
    required void Function(Object exception) onException,
  }) async {
    try {
      final useMintResult =
          await ref.read(solanaTransactionNotifierProvider.notifier).useMint(
                nftAddress: nft.address,
                ownerAddress: nft.ownerAddress,
              );
      useMintResult.fold(
          (exception) => onException(exception), (result) => onOpen(result));
    } catch (exception) {
      onException(exception);
    }
  }

  Future<void> listNft({
    required String sellerAddress,
    required String mintAccount,
    required double price,
    required void Function(String result) callback,
  }) async {
    try {
      final response =
          await ref.read(solanaTransactionNotifierProvider.notifier).list(
                sellerAddress: sellerAddress,
                mintAccount: mintAccount,
                price: (price * lamportsPerSol).round(),
              );
      response.fold(
        (exception) {
          ref.read(privateLoadingProvider.notifier).update((state) => false);
          callback(exception.message);
        },
        (result) async {
          await Future.delayed(
            const Duration(milliseconds: 1200),
            () {
              ref.invalidate(nftProvider);
              ref
                  .read(privateLoadingProvider.notifier)
                  .update((state) => false);
              callback(result);
            },
          );
        },
      );
    } catch (exception) {
      ref.read(privateLoadingProvider.notifier).update((state) => false);
      rethrow;
    }
  }

  mintLoadingListener({
    required VideoPlayerController videoPlayerController,
    required AnimationController animationController,
    required Future Function(NftModel nft) onSuccess,
    required Function() onFail,
  }) async {
    final bool isMinting =
        ref.watch(globalNotifierProvider).isMinting != null &&
            ref.watch(globalNotifierProvider).isMinting!;
    final bool isMinted = ref.watch(lastProcessedNftProvider) != null;
    if (videoPlayerController.value.isPlaying) {
      if (isMinted) {
        await _handleMintedCase(
          videoPlayerController: videoPlayerController,
          animationController: animationController,
          onSuccess: onSuccess,
        );
      }
    } else if (!isMinting && !isMinted) {
      onFail();
    }
  }

  _handleMintedCase({
    required VideoPlayerController videoPlayerController,
    required AnimationController animationController,
    required Future Function(NftModel nft) onSuccess,
  }) async {
    videoPlayerController.pause();
    animationController.reverse(
      from: 1,
    );
    final nft = await ref
        .read(nftProvider(ref.watch(lastProcessedNftProvider)!).future);

    if (nft != null) {
      ref.invalidate(lastProcessedNftProvider);
      ref.invalidate(ownedComicsProvider);
      ref.invalidate(ownedIssuesAsyncProvider);
      ref.invalidate(nftsProvider);
      await onSuccess(nft);
    }
  }

  mintOpenListener({
    required VideoPlayerController videoPlayerController,
    required AnimationController animationController,
    required Function(String nftAddress) onSuccess,
    required Function() onFail,
  }) {
    final bool isMinting =
        ref.watch(globalNotifierProvider).isMinting != null &&
            ref.watch(globalNotifierProvider).isMinting!;
    final bool isMinted = ref.watch(lastProcessedNftProvider) != null;

    if (videoPlayerController.value.isPlaying) {
      if (isMinted) {
        _handleOpenedCase(
          animationController: animationController,
          onSuccess: onSuccess,
          videoPlayerController: videoPlayerController,
        );
      } else if (!isMinting && !isMinted) {
        onFail();
      }
    }
  }

  _handleOpenedCase({
    required VideoPlayerController videoPlayerController,
    required AnimationController animationController,
    required Function(String nftAddress) onSuccess,
  }) {
    videoPlayerController.pause();
    animationController.reverse(
      from: 1,
    );
    final String? nftAddress = ref.read(lastProcessedNftProvider);
    if (nftAddress != null) {
      ref.invalidate(lastProcessedNftProvider);
      ref.invalidate(nftsProvider);
      ref.invalidate(ownedComicsProvider);
      ref.invalidate(ownedIssuesAsyncProvider);
      ref.invalidate(comicIssuePagesProvider);
      ref.invalidate(comicIssueDetailsProvider);
      onSuccess(nftAddress);
    }
  }

  handleNftUnwrap({
    required String nftAddress,
    required String ownerAddress,
    required Function() onSuccess,
  }) async {
    final useMintResult =
        await ref.read(solanaTransactionNotifierProvider.notifier).useMint(
              nftAddress: nftAddress,
              ownerAddress: ownerAddress,
            );
    useMintResult.fold((exception) => null, (result) {
      if (result == 'OK') {
        onSuccess();
      }
    });
  }
}
