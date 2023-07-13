import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/nft_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
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
    _controller = VideoPlayerController.asset(
        'assets/animation_files/loading-animation.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
    _controller.addListener(() async {
      final bool isMinted = ref.watch(globalStateProvider).isMinting != null &&
          !ref.watch(globalStateProvider).isMinting! &&
          ref.watch(lastMintedNftProvider) != null;
      if (_controller.value.isPlaying && isMinted) {
        _controller.pause();
        final nft = await ref
            .read(nftProvider(ref.watch(lastMintedNftProvider)!).future);
        if (context.mounted && nft != null) {
          ref.invalidate(lastMintedNftProvider);
          nextScreenReplace(
            context,
            DoneMintingAnimation(
              nft: nft,
            ),
          );
        }
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
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 250,
                  width: 250,
                  child: VideoPlayer(
                    _controller,
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

class DoneMintingAnimation extends StatefulWidget {
  final NftModel nft;
  const DoneMintingAnimation({
    super.key,
    required this.nft,
  });

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
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: GestureDetector(
            onTap: () {
              nextScreenReplace(
                context,
                NftDetails(
                  address: widget.nft.address,
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FadeTransition(
                    opacity: _animationController,
                    child: CachedNetworkImage(
                      imageUrl: widget.nft.image,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          constraints: const BoxConstraints(
                            maxWidth: 320,
                            maxHeight: 320,
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      },
                      placeholder: (context, url) {
                        return Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            color: ColorPalette.greyscale200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      },
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
