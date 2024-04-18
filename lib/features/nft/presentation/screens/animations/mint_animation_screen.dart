import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/enums.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/nft/presentation/providers/nft_controller.dart';
import 'package:d_reader_flutter/features/nft/presentation/utils/extensions.dart';
import 'package:d_reader_flutter/features/nft/presentation/utils/utils.dart';
import 'package:d_reader_flutter/shared/data/local/local_store.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/utils/url_utils.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/shared/widgets/checkbox/custom_labeled_checkbox.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/rarity.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/royalty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
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
      'assets/animation_files/loading-animation.mp4',
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
    _controller.addListener(() async {
      await ref.read(nftControllerProvider.notifier).mintLoadingListener(
          videoPlayerController: _controller,
          animationController: _animationController,
          onSuccess: (NftModel nft) async {
            await Future.delayed(
              const Duration(milliseconds: 1000),
              () {
                nextScreenReplace(
                  context: context,
                  path: RoutePath.doneMinting,
                  homeSubRoute: true,
                  extra: nft,
                );
              },
            );
          },
          onFail: () {
            _controller.pause();
            context.pop();
          });
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

  _handleUnwrap({required WidgetRef ref}) async {
    await ref.read(nftControllerProvider.notifier).handleNftUnwrap(
          nftAddress: widget.nft.address,
          ownerAddress: widget.nft.ownerAddress,
          onSuccess: () {
            nextScreenReplace(
              context: context,
              path: RoutePath.openNftAnimation,
              homeSubRoute: true,
            );
          },
        );
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
                    context: context,
                    path: '${RoutePath.nftDetails}/${widget.nft.address}',
                    homeSubRoute: true,
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
                      height: 8,
                    ),
                    Text(
                      widget.nft.comicName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ColorPalette.greyscale100,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Congrats! You own ${shortenNftName(widget.nft.name)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
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
                        RarityWidget(
                          rarity: widget.nft.rarity.rarityEnum,
                          iconPath: 'assets/icons/rarity.svg',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        return GestureDetector(
                          onTap: () async {
                            final nft = widget.nft;
                            final dReaderWebUrl = ref
                                        .read(environmentProvider)
                                        .solanaCluster ==
                                    SolanaCluster.devnet.value
                                ? 'https://dev-devnet.dreader.app/mint/${nft.comicIssueId}'
                                : 'https://dreader.app/mint/${nft.comicIssueId}';
                            final uri = Uri.encodeFull(
                              'https://twitter.com/intent/tweet?text=I just minted a ${nft.rarity.toLowerCase()} copy of the ${nft.name.split('#')[0]}!\n\nMint yours here while the supply lasts.👇\n\n$dReaderWebUrl',
                            );
                            await openUrl(uri);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Share on',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                SvgPicture.asset(
                                  'assets/icons/x.svg',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
                      child: CustomTextButton(
                        backgroundColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        borderColor: ColorPalette.greyscale50,
                        textColor: Colors.white,
                        size: const Size(0, 50),
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text(
                          'Close',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final bool isLoading =
                              ref.watch(globalNotifierProvider).isLoading;
                          return CustomTextButton(
                            backgroundColor: ColorPalette.dReaderYellow100,
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            textColor: Colors.black,
                            size: const Size(0, 50),
                            isLoading: isLoading,
                            onPressed: isLoading
                                ? null
                                : () async {
                                    final shouldTriggerDialog = LocalStore
                                            .instance
                                            .get(WalkthroughKeys.unwrap.name) ==
                                        null;
                                    if (!shouldTriggerDialog) {
                                      return await _handleUnwrap(ref: ref);
                                    }

                                    bool isChecked = false;
                                    return triggerWalkthroughDialog(
                                      context: context,
                                      buttonText: 'Unwrap',
                                      onSubmit: () async {
                                        if (isChecked) {
                                          LocalStore.instance.put(
                                            WalkthroughKeys.unwrap.name,
                                            true,
                                          );
                                        }
                                        context.pop();
                                        await _handleUnwrap(ref: ref);
                                      },
                                      title: 'Comic unwraping',
                                      subtitle:
                                          'By unwrapping the comic, you will be able to read it. This action is irreversible and will make the comic lose the mint condition.',
                                      bottomWidget: StatefulBuilder(
                                        builder: (context, setState) {
                                          return CustomLabeledCheckbox(
                                            isChecked: isChecked,
                                            onChange: () {
                                              setState(
                                                () {
                                                  isChecked = !isChecked;
                                                },
                                              );
                                            },
                                            label: Text(
                                              'Don\'t ask me again',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          );
                                        },
                                      ),
                                      assetPath: '',
                                    );
                                  },
                            child: const Text(
                              'Unwrap',
                            ),
                          );
                        },
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
