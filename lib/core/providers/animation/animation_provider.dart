import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/features/comic/presentation/providers/owned_comics_notifier.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/presentation/providers/owned_issues_notifier.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';
part 'animation_provider.g.dart';

@riverpod
class AnimationNotifier extends _$AnimationNotifier {
  @override
  FutureOr<void> build() {}

  mintLoadingListener({
    required BuildContext context,
    required VideoPlayerController videoPlayerController,
    required AnimationController animationController,
    required Future Function(NftModel nft) onSuccess,
  }) async {
    final bool isMinting = ref.watch(globalStateProvider).isMinting != null &&
        ref.watch(globalStateProvider).isMinting!;
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
      videoPlayerController.pause();
      context.pop();
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
      ref.invalidate(ownedComicsAsyncProvider);
      ref.invalidate(ownedIssuesAsyncProvider);
      ref.invalidate(nftsProvider);
      await onSuccess(nft);
    }
  }

  mintOpenListener({
    required BuildContext context,
    required VideoPlayerController videoPlayerController,
    required AnimationController animationController,
    required Function(String nftAddress) onSuccess,
    required Function() onFail,
  }) {
    final bool isMinting = ref.watch(globalStateProvider).isMinting != null &&
        ref.watch(globalStateProvider).isMinting!;
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
      ref.invalidate(ownedComicsAsyncProvider);
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
    final isSuccessful = await ref.read(solanaProvider.notifier).useMint(
          nftAddress: nftAddress,
          ownerAddress: ownerAddress,
        );
    if (isSuccessful) {
      onSuccess();
    }
  }
}
