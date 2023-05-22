import 'package:d_reader_flutter/core/models/page_model.dart';
import 'package:d_reader_flutter/core/providers/app_bar/app_bar_visibility.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/animated_app_bar.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/cover_cached_image.dart';
import 'package:d_reader_flutter/ui/widgets/e_reader/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EReaderView extends ConsumerWidget {
  final int issueId;
  const EReaderView({
    super.key,
    required this.issueId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<PageModel>> pagesProvider =
        ref.watch(comicIssuePagesProvider(issueId));
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
      child: Scaffold(
        backgroundColor: ColorPalette.appBackgroundColor,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: const Size(0, 64),
          child: VisibilityAnimationAppBar(
            title: 'Episode 5',
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  Icons.bookmark_outline_rounded,
                  color: ColorPalette.boxBackground400.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        body: pagesProvider.when(
          data: (pages) {
            return GestureDetector(
              onTap: () {
                if (!ref.read(isAppBarVisibleProvider)) {
                  notifier.update(
                    (state) {
                      return true;
                    },
                  );
                }
              },
              child: InteractiveViewer(
                minScale: 0.1, // Minimum scale allowed
                maxScale: 10, // Maximum scale allowed
                panEnabled: true,
                scaleEnabled: true,
                constrained: true,
                child: ListView.builder(
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return CommonCachedImage(
                      imageUrl: pages[index].image,
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
        ),
      ),
    );
  }
}
