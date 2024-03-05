import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/core/providers/app_bar/app_bar_visibility.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/e_reader/reading_switch_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/features/nft/presentations/providers/nft_providers.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/shared/domain/models/comic_page.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/animated_app_bar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/image_widgets/common_cached_image.dart';
import 'package:d_reader_flutter/ui/widgets/e_reader/bottom_navigation.dart';
import 'package:d_reader_flutter/ui/widgets/e_reader/page_number_widget.dart';
import 'package:d_reader_flutter/ui/widgets/library/modals/owned_nfts_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class EReaderView extends ConsumerStatefulWidget {
  final int issueId;
  const EReaderView({
    super.key,
    required this.issueId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EReaderViewState();
}

class _EReaderViewState extends ConsumerState<EReaderView>
    with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;

  TapDownDetails? tapDownDetails;
  Animation<Matrix4>? animation;

  bool _isPageChangeEnabled = true;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    )..addListener(() {
        if (animation?.value != null) {
          _transformationController.value = animation!.value;
        }
      });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<PageModel>> pagesProvider =
        ref.watch(comicIssuePagesProvider(widget.issueId));
    AsyncValue<ComicIssueModel?> issueProvider =
        ref.watch(comicIssueDetailsProvider(widget.issueId));
    final notifier = ref.read(isAppBarVisibleProvider.notifier);
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          if (ref.read(isAppBarVisibleProvider)) {
            notifier.update(
              (state) {
                return false;
              },
            );
          }
        }
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorPalette.appBackgroundColor,
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: PreferredSize(
            preferredSize: const Size(0, 64),
            child: VisibilityAnimationAppBar(
              title: issueProvider.value?.title ?? '',
              centerTitle: false,
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(comicIssuePagesProvider);
            },
            backgroundColor: ColorPalette.dReaderYellow100,
            color: ColorPalette.appBackgroundColor,
            child: pagesProvider.when(
              data: (pages) {
                if (issueProvider.value == null) {
                  return const SizedBox();
                }
                bool isFullyUploaded = issueProvider.value!.isFullyUploaded;
                bool canRead = issueProvider.value!.myStats != null &&
                    issueProvider.value!.myStats!.canRead;
                bool showPreviewableImage = !canRead || !isFullyUploaded;

                return GestureDetector(
                  onTap: () {
                    notifier
                        .update((state) => !ref.read(isAppBarVisibleProvider));
                  },
                  onDoubleTapDown: (details) {
                    tapDownDetails = details;
                  },
                  onDoubleTap: () {
                    final position = tapDownDetails?.localPosition;
                    const double scale = 3;
                    final x = (-position!.dx) * (scale - 1);
                    final y = (-position.dy) * (scale - 1);

                    final zoomed = Matrix4.identity()
                      ..translate(x, y)
                      ..scale(scale);
                    final end = _transformationController.value.isIdentity()
                        ? zoomed
                        : Matrix4.identity();

                    animation = Matrix4Tween(
                      begin: _transformationController.value,
                      end: end,
                    ).animate(
                      CurveTween(curve: Curves.easeOut).animate(
                        _animationController,
                      ),
                    );

                    _animationController.forward(from: 0);
                    if (ref.read(isPageByPageReadingMode)) {
                      setState(() {
                        _isPageChangeEnabled = end.getMaxScaleOnAxis() <= 1;
                      });
                    }
                  },
                  child: ref.watch(isPageByPageReadingMode)
                      ? PageView.builder(
                          pageSnapping: true,
                          physics: _isPageChangeEnabled
                              ? const PageScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          allowImplicitScrolling: true,
                          itemCount: showPreviewableImage
                              ? pages.length + 1
                              : pages.length,
                          itemBuilder: (context, index) {
                            ValueNotifier<int> valueNotifier =
                                ValueNotifier(index);
                            return MyInteractiveViewer(
                              minScale: 0.1,
                              maxScale: 4,
                              panEnabled: true,
                              scaleEnabled: true,
                              transformationController:
                                  _transformationController,
                              onInteractionEnd: (scaleDetails) {
                                double scale = _transformationController.value
                                    .getMaxScaleOnAxis();
                                setState(() {
                                  _isPageChangeEnabled = scale <= 1;
                                });
                              },
                              constrained: true,
                              child: index == pages.length
                                  ? Center(
                                      child: PreviewImage(
                                        canRead: canRead,
                                        isFullyUploaded: isFullyUploaded,
                                        issueId: widget.issueId,
                                        issueNumber:
                                            issueProvider.value!.number,
                                      ),
                                    )
                                  : ValueListenableBuilder(
                                      valueListenable: valueNotifier,
                                      builder: (context, value, child) {
                                        return Stack(
                                          children: [
                                            CommonCachedImage(
                                              fit: BoxFit.contain,
                                              placeholder: Container(
                                                height: 400,
                                                width: double.infinity,
                                                color:
                                                    ColorPalette.greyscale400,
                                              ),
                                              imageUrl: pages[index].image,
                                              onError: () {
                                                ++valueNotifier.value;
                                              },
                                            ),
                                            Positioned.fill(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  top: 72,
                                                  right: 16,
                                                ),
                                                alignment: Alignment.topRight,
                                                child: PageNumberWidget(
                                                  pageNumber:
                                                      pages[index].pageNumber,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                            );
                          },
                        )
                      : MyInteractiveViewer(
                          minScale: 1,
                          maxScale: 4,
                          panEnabled: true,
                          transformationController: _transformationController,
                          scaleEnabled: true,
                          constrained: true,
                          child: ListView.builder(
                            itemCount: showPreviewableImage
                                ? pages.length + 1
                                : pages.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              ValueNotifier<int> valueNotifier =
                                  ValueNotifier(index);
                              return index == pages.length
                                  ? PreviewImage(
                                      canRead: canRead,
                                      isFullyUploaded: isFullyUploaded,
                                      issueId: widget.issueId,
                                      issueNumber: issueProvider.value!.number,
                                    )
                                  : ValueListenableBuilder(
                                      valueListenable: valueNotifier,
                                      builder: (context, value, child) {
                                        return Stack(
                                          children: [
                                            CommonCachedImage(
                                              placeholder: Container(
                                                height: 400,
                                                width: double.infinity,
                                                color:
                                                    ColorPalette.greyscale400,
                                              ),
                                              imageUrl: pages[index].image,
                                              onError: () {
                                                ++valueNotifier.value;
                                              },
                                            ),
                                            Positioned.fill(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  top: 72,
                                                  right: 16,
                                                ),
                                                alignment: Alignment.topRight,
                                                child: PageNumberWidget(
                                                  pageNumber:
                                                      pages[index].pageNumber,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                            },
                          ),
                        ),
                );
              },
              error: (Object error, StackTrace stackTrace) {
                return Text('Error in eReader: ${error.toString()}');
              },
              loading: () {
                return const SkeletonCard(
                  width: double.infinity,
                  height: 400,
                );
              },
            ),
          ),
          bottomNavigationBar: EReaderBottomNavigation(
            totalPages: pagesProvider.value?.length ?? 0,
            rating: issueProvider.value?.stats?.averageRating ?? 0,
            issueId: widget.issueId,
            favouritesCount: issueProvider.value?.stats?.favouritesCount ?? 0,
            isFavourite: issueProvider.value?.myStats?.isFavourite ?? false,
          ),
        ),
      ),
    );
  }
}

class PreviewImage extends StatelessWidget {
  final bool canRead, isFullyUploaded;
  final int issueId, issueNumber;
  const PreviewImage({
    super.key,
    required this.canRead,
    required this.isFullyUploaded,
    required this.issueId,
    required this.issueNumber,
  });

  openModalBottomSheet(BuildContext context, List<NftModel> ownedNfts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: ownedNfts.length > 1 ? 0.65 : 0.5,
          minChildSize: ownedNfts.length > 1 ? 0.65 : 0.5,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return OwnedNftsBottomSheet(
              ownedNfts: ownedNfts,
              episodeNumber: issueNumber,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 240),
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/icons/comic_preview.svg',
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Icon(
                    FontAwesomeIcons.eyeSlash,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                !canRead || !isFullyUploaded
                    ? Text(
                        'This is a comic preview!',
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    : const SizedBox(),
                canRead
                    ? const SizedBox()
                    : Text(
                        'To view all pages buy a full copy or become a monthly subscriber',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                Consumer(
                  builder: (context, ref, child) {
                    final ownedNfts = ref.watch(
                      nftsProvider(
                        'comicIssueId=$issueId&userId=${ref.read(environmentProvider).user?.id}',
                      ),
                    );

                    return ownedNfts.when(
                      data: (data) {
                        if (data.isEmpty) {
                          return const SizedBox();
                        }

                        final isAtLeastOneUsed = data.any((nft) => nft.isUsed);
                        return isAtLeastOneUsed && canRead
                            ? const SizedBox()
                            : CustomTextButton(
                                backgroundColor: ColorPalette.dReaderYellow100,
                                fontSize: 16,
                                isLoading: ref.watch(privateLoadingProvider),
                                textColor: Colors.black,
                                onPressed: () {
                                  final privateLoadingNotifier =
                                      ref.read(privateLoadingProvider.notifier);
                                  privateLoadingNotifier
                                      .update((state) => true);
                                  openModalBottomSheet(context, data);
                                  privateLoadingNotifier
                                      .update((state) => false);
                                },
                                child: const Text(
                                  'Unwrap',
                                ),
                              );
                      },
                      error: (error, stackTrace) {
                        Sentry.captureException(
                          error,
                          stackTrace: 'eReader owned Nfts: $stackTrace',
                        );
                        return const SizedBox();
                      },
                      loading: () {
                        return const SizedBox();
                      },
                    );
                  },
                ),
                isFullyUploaded
                    ? const SizedBox()
                    : Text(
                        'This comic is not yet fully uploaded. New chapters might be added weekly or the comic is still in a presale phase',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyInteractiveViewer extends StatelessWidget {
  final Widget child;
  final TransformationController? transformationController;
  final double minScale, maxScale;
  final bool panEnabled, scaleEnabled, constrained;
  final void Function(ScaleEndDetails)? onInteractionEnd;
  final void Function(ScaleStartDetails)? onInteractionStart;
  const MyInteractiveViewer({
    super.key,
    required this.child,
    this.transformationController,
    this.minScale = 0.1,
    this.maxScale = 4,
    this.panEnabled = true,
    this.scaleEnabled = false,
    this.constrained = false,
    this.onInteractionEnd,
    this.onInteractionStart,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      minScale: minScale,
      maxScale: maxScale,
      panEnabled: panEnabled,
      transformationController: transformationController,
      scaleEnabled: scaleEnabled,
      constrained: constrained,
      onInteractionEnd: onInteractionEnd,
      onInteractionStart: onInteractionStart,
      child: child,
    );
  }
}
