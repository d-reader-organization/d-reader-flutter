import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/page_model.dart';
import 'package:d_reader_flutter/core/providers/app_bar/app_bar_visibility.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/e_reader/reading_switch_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/animated_app_bar.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/common_cached_image.dart';
import 'package:d_reader_flutter/ui/widgets/e_reader/bottom_navigation.dart';
import 'package:d_reader_flutter/ui/widgets/e_reader/page_number_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
              // actions: [
              //   Padding(
              //     padding: const EdgeInsets.only(right: 16.0),
              //     child: Icon(
              //       Icons.bookmark_outline_rounded,
              //       color: ColorPalette.boxBackground400.withOpacity(0.6),
              //     ),
              //   ),
              // ],
            ),
          ),
          body: pagesProvider.when(
            data: (pages) {
              bool canRead = (issueProvider.value?.isFreeToRead != null &&
                      !issueProvider.value!.isFreeToRead) &&
                  (issueProvider.value?.myStats?.canRead != null &&
                      issueProvider.value!.myStats!.canRead);
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
                        itemCount: canRead ? pages.length : pages.length + 1,
                        itemBuilder: (context, index) {
                          ValueNotifier<int> valueNotifier =
                              ValueNotifier(index);
                          return MyInteractiveViewer(
                            minScale: 0.1,
                            maxScale: 4,
                            panEnabled: true,
                            scaleEnabled: true,
                            transformationController: _transformationController,
                            onInteractionEnd: (scaleDetails) {
                              double scale = _transformationController.value
                                  .getMaxScaleOnAxis();
                              setState(() {
                                _isPageChangeEnabled = scale <= 1;
                              });
                            },
                            constrained: true,
                            child: index == pages.length
                                ? PreviewImage(
                                    canRead:
                                        issueProvider.value?.myStats?.canRead ??
                                            false,
                                    isFullyUploaded:
                                        issueProvider.value?.isFullyUploaded ??
                                            false,
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
                                                  ColorPalette.boxBackground300,
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
                          itemCount: canRead ? pages.length : pages.length + 1,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            ValueNotifier<int> valueNotifier =
                                ValueNotifier(index);
                            return index == pages.length
                                ? PreviewImage(
                                    canRead:
                                        issueProvider.value?.myStats?.canRead ??
                                            false,
                                    isFullyUploaded:
                                        issueProvider.value?.isFullyUploaded ??
                                            false,
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
                                                  ColorPalette.boxBackground300,
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
  const PreviewImage({
    super.key,
    required this.canRead,
    required this.isFullyUploaded,
  });

  final textStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

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
                const Text(
                  'This is a comic preview!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                canRead
                    ? const SizedBox()
                    : Text(
                        'To view all pages buy a full copy or become a monthly subscriber',
                        textAlign: TextAlign.center,
                        style: textStyle,
                      ),
                isFullyUploaded
                    ? const SizedBox()
                    : Text(
                        'This comic is not yet fully uploaded. New chapters might be added weekly or the comic is still in a presale phase',
                        textAlign: TextAlign.center,
                        style: textStyle,
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
