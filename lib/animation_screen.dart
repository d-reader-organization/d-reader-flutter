import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

class AnimationDialog extends StatelessWidget {
  const AnimationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return MintLoadingAnimation(
          isPortrait: orientation == Orientation.portrait,
        );
      },
    );
  }
}

class MintLoadingAnimation extends ConsumerStatefulWidget {
  final bool isPortrait;
  const MintLoadingAnimation({
    super.key,
    this.isPortrait = true,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MintLoadingAnimationState();
}

class _MintLoadingAnimationState extends ConsumerState<MintLoadingAnimation> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.isPortrait
        ? 'assets/animation_files/bunbun_reveal.mp4'
        : 'assets/animation_files/landscape_bunbun_reveal.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
    _controller.addListener(() {
      if (_controller.value.duration != Duration.zero &&
          ref.watch(globalStateProvider).isMinting != null &&
          !ref.watch(globalStateProvider).isMinting!) {
        // fetch NFT
        // display in Done Minting Animation.
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return const DoneMintingAnimation();
          },
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: ColorPalette.appBackgroundColor,
      content: SizedBox(
        width: 248,
        height: 248,
        child: Stack(
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return VideoPlayer(_controller);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            Positioned.fill(
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Confirming transaction',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoneMintingAnimation extends StatefulWidget {
  const DoneMintingAnimation({super.key});

  @override
  State<DoneMintingAnimation> createState() => _DoneMintingAnimationState();
}

class _DoneMintingAnimationState extends State<DoneMintingAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorPalette.appBackgroundColor,
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: 248,
        height: 248,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FadeTransition(
                    opacity: _animationController,
                    child: Container(
                      color: Colors.yellow,
                      child: SvgPicture.asset('assets/images/logo_alpha.svg'),
                    ),
                  ),
                ),
                CustomTextButton(
                  backgroundColor: ColorPalette.dReaderGreen,
                  borderRadius: BorderRadius.circular(8),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Close',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
