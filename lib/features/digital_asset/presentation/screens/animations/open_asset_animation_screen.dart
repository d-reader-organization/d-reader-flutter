import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/providers/digital_asset_controller.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

class OpenDigitalAssetAnimation extends ConsumerStatefulWidget {
  const OpenDigitalAssetAnimation({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OpenDigitalAssetAnimation();
}

class _OpenDigitalAssetAnimation
    extends ConsumerState<OpenDigitalAssetAnimation>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
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
      ref.read(digitalAssetControllerProvider.notifier).mintOpenListener(
            videoPlayerController: _controller,
            animationController: _animationController,
            onSuccess: (int comicIssueId) {
              nextScreenReplace(
                context: context,
                path: '${RoutePath.eReader}/$comicIssueId',
                homeSubRoute: true,
              );
            },
            onFail: () {
              _controller.pause();
              context.pop();
              showSnackBar(
                context: context,
                text: 'Failed to unwrap.',
                backgroundColor: ColorPalette.dReaderRed,
              );
              return;
            },
          );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(registerWalletToSocketEvents);
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
