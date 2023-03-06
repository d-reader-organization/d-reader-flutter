import 'package:d_reader_flutter/core/models/page_model.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/cover_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EReaderView extends ConsumerWidget {
  final int issueId;
  const EReaderView({super.key, required this.issueId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<PageModel>> pagesProvider =
        ref.watch(comicIssuePagesProvider(issueId));
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: pagesProvider.when(
        data: (pages) {
          return ListView.builder(
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return CommonCachedImage(imageUrl: pages[index].image);
            },
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
    );
  }
}
