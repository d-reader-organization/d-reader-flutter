import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/core/notifiers/owned_comics_notifier.dart';
import 'package:d_reader_flutter/core/notifiers/owned_issues_notifier.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

class OpenNftAnimation extends ConsumerStatefulWidget {
  const OpenNftAnimation({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OpenNftAnimationState();
}

class _OpenNftAnimationState extends ConsumerState<OpenNftAnimation>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    ref.read(registerWalletToSocketEvents);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
    _controller = VideoPlayerController.asset(
        'assets/animation_files/loading-animation.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.play();

    _controller.addListener(() {
      final bool isMinting = ref.watch(globalStateProvider).isMinting != null &&
          ref.watch(globalStateProvider).isMinting!;
      final bool isMinted = ref.watch(lastProcessedNftProvider) != null;

      if (_controller.value.isPlaying) {
        if (isMinted) {
          _handleMintedCase();
        } else if (!isMinting && !isMinted) {
          _controller.pause();
          Navigator.pop(context);
          showSnackBar(
            context: context,
            text: 'Internal server error.',
            backgroundColor: ColorPalette.dReaderRed,
          );
          return;
        }
      }
    });
  }

  _handleMintedCase() {
    _controller.pause();
    _animationController.reverse(
      from: 1,
    );
    final String? nftAddress = ref.read(lastProcessedNftProvider);
    if (context.mounted && nftAddress != null) {
      ref.invalidate(lastProcessedNftProvider);
      ref.invalidate(nftsProvider);
      ref.invalidate(ownedComicsAsyncProvider);
      ref.invalidate(ownedIssuesAsyncProvider);
      ref.invalidate(comicIssuePagesProvider);
      ref.invalidate(comicIssueDetailsProvider);
      nextScreenReplace(
        context: context,
        path: '${RoutePath.nftDetails}/$nftAddress',
        homeSubRoute: true,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return FadeTransition(
                opacity: _animationController,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 250,
                    width: 250,
                    child: VideoPlayer(
                      _controller,
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
