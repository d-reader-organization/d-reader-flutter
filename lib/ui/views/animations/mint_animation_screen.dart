import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/notifiers/owned_comics_notifier.dart';
import 'package:d_reader_flutter/core/notifiers/owned_issues_notifier.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/shorten_nft_name.dart';
import 'package:d_reader_flutter/ui/views/animations/open_nft_animation_screen.dart';
import 'package:d_reader_flutter/ui/views/nft_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/royalty.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

class MintLoadingAnimation extends ConsumerStatefulWidget {
  const MintLoadingAnimation({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MintLoadingAnimationState();
}

class _MintLoadingAnimationState extends ConsumerState<MintLoadingAnimation>
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
    _controller.addListener(() async {
      final bool isMinting = ref.watch(globalStateProvider).isMinting != null &&
          ref.watch(globalStateProvider).isMinting!;
      final bool isMinted = ref.watch(lastProcessedNftProvider) != null;
      if (_controller.value.isPlaying) {
        if (isMinted) {
          await _handleMintedCase();
        }
      } else if (!isMinting && !isMinted) {
        _controller.pause();
        Navigator.pop(context);
      }
    });
  }

  _handleMintedCase() async {
    _controller.pause();
    _animationController.reverse(
      from: 1,
    );
    final nft = await ref
        .read(nftProvider(ref.watch(lastProcessedNftProvider)!).future);

    if (context.mounted && nft != null) {
      ref.invalidate(lastProcessedNftProvider);
      ref.invalidate(ownedComicsAsyncProvider);
      ref.invalidate(ownedIssuesAsyncProvider);
      ref.invalidate(nftsProvider);
      await Future.delayed(
        const Duration(milliseconds: 1000),
        () {
          nextScreenReplace(
            context,
            DoneMintingAnimation(
              nft: nft,
            ),
          );
        },
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
    with TickerProviderStateMixin {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late final AnimationController _animationController;
  late final AnimationController _bgAnimationController;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/animation_files/nft-mint-bg.mp4');
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.play();

    _bgAnimationController.forward();
    Future.delayed(
      const Duration(
        milliseconds: 2000,
      ),
      () {
        _animationController.forward();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    _bgAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: FadeTransition(
        opacity: _bgAnimationController,
        child: Stack(
          children: [
            FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return VideoPlayer(
                    _controller,
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            FadeTransition(
              opacity: _animationController,
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
                  children: [
                    AspectRatio(
                      aspectRatio: 276 / 220,
                      child: CachedNetworkImage(
                        imageUrl: widget.nft.image,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      widget.nft.comicName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Congrats you own ${shortenNftName(widget.nft.name)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const RoyaltyWidget(
                          iconPath: 'assets/icons/mint_icon.svg',
                          text: 'Mint',
                          color: ColorPalette.dReaderGreen,
                        ),
                        widget.nft.isSigned
                            ? const RoyaltyWidget(
                                iconPath: 'assets/icons/signed_icon.svg',
                                text: 'Signed',
                                color: ColorPalette.dReaderOrange,
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            FadeTransition(
              opacity: _animationController,
              child: Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final bool isLoading =
                              ref.watch(globalStateProvider).isLoading;
                          return CustomTextButton(
                            backgroundColor: ColorPalette.dReaderYellow100,
                            padding: const EdgeInsets.all(4),
                            borderRadius: BorderRadius.circular(8),
                            textColor: Colors.black,
                            isLoading: isLoading,
                            onPressed: isLoading
                                ? null
                                : () async {
                                    final isSuccessful = await ref
                                        .read(solanaProvider.notifier)
                                        .useMint(
                                          nftAddress: widget.nft.address,
                                          ownerAddress: widget.nft.ownerAddress,
                                        );
                                    if (context.mounted && isSuccessful) {
                                      nextScreenReplace(
                                        context,
                                        const OpenNftAnimation(),
                                      );
                                    }
                                  },
                            child: const Text(
                              'Unwrap',
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: CustomTextButton(
                        backgroundColor: ColorPalette.dReaderGreen,
                        padding: const EdgeInsets.all(4),
                        borderRadius: BorderRadius.circular(8),
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Done',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
