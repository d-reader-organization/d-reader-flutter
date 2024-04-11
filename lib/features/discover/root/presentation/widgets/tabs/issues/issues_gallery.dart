import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/widgets/cards/skeleton_card.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/tabs/issues/issues_gallery_builder.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/carrot_error_widget.dart';
import 'package:flutter/material.dart';

class IssuesGallery extends StatelessWidget {
  final PaginationState<ComicIssueModel> provider;
  const IssuesGallery({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return provider.when(
      data: (issues) {
        return IssuesGalleryBuilder(issues: issues);
      },
      error: (err, stack) {
        return const CarrotErrorWidget(
          mainErrorText: 'We ran into some issues',
          adviceText: 'We are working on a fix. Thanks for your patience!',
        );
      },
      loading: () => const IssuesGallerySkeleton(),
      onGoingError: (List<ComicIssueModel> items, Object? e, StackTrace? stk) {
        return IssuesGalleryBuilder(
          issues: items,
        );
      },
      onGoingLoading: (List<ComicIssueModel> items) {
        return IssuesGalleryBuilder(
          issues: items,
        );
      },
    );
  }
}

class IssuesGallerySkeleton extends StatelessWidget {
  const IssuesGallerySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.sizeOf(context).width > 600;
    return GridView.builder(
      itemCount: 4,
      primary: false,
      padding: const EdgeInsets.only(
        left: 4,
        top: 8,
      ),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 156 / 226,
      ),
      itemBuilder: (context, index) {
        return const SkeletonCard();
      },
    );
  }
}
