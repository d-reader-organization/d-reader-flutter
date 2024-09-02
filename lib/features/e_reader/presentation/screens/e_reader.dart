import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/e_reader/presentation/utils/utils.dart';
import 'package:d_reader_flutter/features/e_reader/presentation/widgets/page_widget.dart';
import 'package:d_reader_flutter/features/e_reader/presentation/widgets/preview_image.dart';
import 'package:d_reader_flutter/shared/domain/models/comic_page.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/layout/animated_app_bar.dart';
import 'package:d_reader_flutter/shared/widgets/cards/skeleton_card.dart';
import 'package:d_reader_flutter/features/e_reader/presentation/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vector_math/vector_math_64.dart' show Quad, Vector3;

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

  Rect axisAlignedBoundingBox(Quad quad) {
    double? xMin;
    double? xMax;
    double? yMin;
    double? yMax;
    for (final Vector3 point in <Vector3>[
      quad.point0,
      quad.point1,
      quad.point2,
      quad.point3
    ]) {
      if (xMin == null || point.x < xMin) {
        xMin = point.x;
      }
      if (xMax == null || point.x > xMax) {
        xMax = point.x;
      }
      if (yMin == null || point.y < yMin) {
        yMin = point.y;
      }
      if (yMax == null || point.y > yMax) {
        yMax = point.y;
      }
    }
    return Rect.fromLTRB(xMin!, yMin!, xMax!, yMax!);
  }

  bool _shouldDisplayRow(
    int currentRowIndex,
    List<double> pageDYPositions,
    double top,
    double bottom,
  ) {
    final (bottomBorder, topBorder) = (
      pageDYPositions[currentRowIndex],
      pageDYPositions[currentRowIndex + 1]
    );

    return (bottomBorder <= bottom) && (top <= topBorder);
  }

  bool _isCellVisible(int row, List<double> pageDYPositions, Quad viewport) {
    final Rect aabb = axisAlignedBoundingBox(viewport);
    return _shouldDisplayRow(row, pageDYPositions, aabb.top, aabb.bottom);
  }

  @override
  void initState() {
    super.initState();
    // final Matrix4? initialPosition = LocalStore.eReaderInstance
    //     .get('${widget.issueId}_$eReaderListPositionKey');
    // _transformationController = TransformationController(initialPosition);
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
    // LocalStore.eReaderInstance.put('${widget.issueId}_$eReaderListPositionKey',
    //     _transformationController.value);
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<List<PageModel>> pagesProvider =
        ref.watch(comicIssuePagesProvider(widget.issueId));
    AsyncValue<ComicIssueModel?> issueProvider =
        ref.watch(comicIssueDetailsProvider('${widget.issueId}'));
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
            preferredSize: const Size(0, 56),
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
                final int totalPagesCount =
                    showPreviewableImage ? pages.length + 1 : pages.length;

                List<double> pageDYPositions =
                    pages.fold([0], (previousValue, page) {
                  final double currentPageHeight = calcPageImageHeight(
                    context: context,
                    imageHeight: page.height,
                    imageWidth: page.width,
                  );
                  final double newItem =
                      currentPageHeight + (previousValue.lastOrNull ?? 0);

                  return [...previousValue, newItem];
                });

                return GestureDetector(
                  onTap: () {
                    notifier
                        .update((state) => !ref.read(isAppBarVisibleProvider));
                  },
                  // child: ref.watch(isPageByPageReadingMode)
                  //     ? Column(
                  //         children: [
                  //           Expanded(
                  //             child: Center(
                  //               child: PageView.builder(
                  //                 physics: const NeverScrollableScrollPhysics(),
                  //                 itemCount: totalPagesCount,
                  //                 controller: _pageController,
                  //                 onPageChanged: (value) {
                  //                   print(
                  //                       'page controlelr pages: ${_pageController.page?.toInt()}');
                  //                 },
                  //                 itemBuilder: (context, index) {
                  //                   return InteractiveViewer(
                  //                     panEnabled: true,
                  //                     scaleEnabled: true,
                  //                     maxScale: 10,
                  //                     child: index == pages.length
                  //                         ? Center(
                  //                             child: PreviewImage(
                  //                               canRead: canRead,
                  //                               isFullyUploaded:
                  //                                   isFullyUploaded,
                  //                               issueId: widget.issueId,
                  //                               issueNumber:
                  //                                   issueProvider.value!.number,
                  //                             ),
                  //                           )
                  //                         : PageWidget(
                  //                             row: index,
                  //                             isPageByPage: true,
                  //                             page: pages[index],
                  //                           ),
                  //                   );
                  //                 },
                  //               ),
                  //             ),
                  //           ),
                  //           ScrollingArrowsWidget(
                  //             currentPage: ref.watch(
                  //                 currentPageProvider(_currentPageInView)),
                  //             totalPagesCount: totalPagesCount,
                  //             onPageChange: (page) {
                  //               _pageController
                  //                   .animateToPage(
                  //                 page,
                  //                 duration: const Duration(
                  //                   milliseconds: 300,
                  //                 ),
                  //                 curve: Curves.easeIn,
                  //               )
                  //                   .then(
                  //                 (value) {
                  //                   ref
                  //                       .read(currentPageProvider(
                  //                               _currentPageInView)
                  //                           .notifier)
                  //                       .update((state) => page);
                  //                   LocalStore.eReaderInstance.put(
                  //                     '${widget.issueId}_$eReaderPagePositionKey',
                  //                     page,
                  //                   );
                  //                 },
                  //               );
                  //             },
                  //           ),
                  //           const SizedBox(
                  //             height: 50,
                  //           ),
                  //         ],
                  //       )
                  //     :
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return InteractiveViewer.builder(
                        panEnabled: true,
                        transformationController: _transformationController,
                        scaleEnabled: true,
                        maxScale: 10,
                        builder: (context, viewport) {
                          return Column(
                            children: [
                              for (int row = 0; row < totalPagesCount; ++row)
                                row == pages.length
                                    ? Container(
                                        padding: const EdgeInsets.all(12),
                                        width: constraints.maxWidth,
                                        margin: pages.isEmpty
                                            ? const EdgeInsets.only(top: 48)
                                            : null,
                                        child: PreviewImage(
                                          canRead: canRead,
                                          isFullyUploaded: isFullyUploaded,
                                          issueId: widget.issueId,
                                          issueNumber:
                                              issueProvider.value!.number,
                                        ),
                                      )
                                    : _isCellVisible(
                                        row,
                                        pageDYPositions,
                                        viewport,
                                      )
                                        ? PageWidget(
                                            row: row,
                                            page: pages[row],
                                          )
                                        : SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            height: row == pages.length
                                                ? previewImageHeight
                                                : calcPageImageHeight(
                                                    context: context,
                                                    imageHeight:
                                                        pages[row].height,
                                                    imageWidth:
                                                        pages[row].width,
                                                  ),
                                          ),
                            ],
                          );
                        },
                      );
                    },
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
