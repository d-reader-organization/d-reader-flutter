import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/views/nft_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
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

    Future.delayed(
      const Duration(seconds: 15),
      () {
        final bool isMinting =
            (ref.read(globalStateProvider).isMinting == null ||
                ref.read(globalStateProvider).isMinting == false);
        final bool isMinted = ref.watch(lastProcessedNftProvider) != null;

        if (_controller.value.isPlaying) {
          if (isMinted) {
            return _handleMintedCase();
          } else if (!isMinting && !isMinted) {
            Navigator.pop(context);
            showSnackBar(
              context: context,
              text: 'Internal server error.',
              duration: 2500,
              backgroundColor: ColorPalette.dReaderRed,
            );
            return;
          }
          Navigator.pop(context);
        }
      },
    );
  }

  _handleMintedCase() {
    _controller.pause();
    _animationController.reverse(
      from: 1,
    );
    final String? nftAddress = ref.read(lastProcessedNftProvider);
    if (context.mounted && nftAddress != null) {
      ref.invalidate(lastProcessedNftProvider);
      nextScreenReplace(
        context,
        _SuccessAnimation(
          handler: () {
            nextScreenReplace(
              context,
              NftDetails(
                address: nftAddress,
              ),
            );
          },
        ),
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

class _SuccessAnimation extends StatefulWidget {
  final Function() handler;

  const _SuccessAnimation({
    required this.handler,
  });

  @override
  State<_SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<_SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    Future.delayed(
      const Duration(
        milliseconds: 1000,
      ),
      () {
        _animationController.forward();
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: FadeTransition(
        opacity: _animationController,
        child: Center(
          child: CustomTextButton(
            onPressed: widget.handler,
            backgroundColor: ColorPalette.dReaderGreen,
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(8),
            child: const Text(
              'Read now',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
