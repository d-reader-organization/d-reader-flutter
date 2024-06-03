import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/providers/filter_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/utils/render_carrot_error.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/tabs/cards/comic_issue_card_large.dart';
import 'package:d_reader_flutter/features/comic/presentation/widgets/details/scaffold.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/common/on_going_bottom.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/tabs/issues/issues_gallery_builder.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/carrot_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComicDetails extends ConsumerWidget {
  final String slug;
  const ComicDetails({
    super.key,
    required this.slug,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ComicModel> provider = ref.watch(comicSlugProvider(slug));
    final issuesProvider = ref.watch(
      paginatedIssuesProvider(
        'comicSlug=$slug&sortTag=latest&sortOrder=${getSortDirection(ref.watch(comicSortDirectionProvider))}',
      ),
    );
    final bool isDetailedViewMode =
        ref.watch(comicViewModeProvider) == ViewMode.detailed;
    return provider.when(
      data: (comic) {
        return ComicDetailsScaffold(
          comic: comic,
          loadMore: ref
              .read(
                paginatedIssuesProvider(
                        'comicSlug=$slug&sortTag=latest&sortOrder=${getSortDirection(ref.watch(comicSortDirectionProvider))}')
                    .notifier,
              )
              .fetchNext,
          body: CustomScrollView(
            shrinkWrap: true,
            physics: const PageScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (context, index) {
                    return issuesProvider.when(
                      data: (List<ComicIssueModel> issues) {
                        return isDetailedViewMode
                            ? _IssuesList(issues: issues)
                            : IssuesGalleryBuilder(
                                issues: issues,
                              );
                      },
                      error: (Object? e, StackTrace? stk) {
                        return const CarrotErrorWidget();
                      },
                      loading: () {
                        return const SizedBox();
                      },
                      onGoingError: (List<ComicIssueModel> items, Object? e,
                          StackTrace? stk) {
                        return isDetailedViewMode
                            ? _IssuesList(issues: items)
                            : IssuesGalleryBuilder(issues: items);
                      },
                      onGoingLoading: (List<ComicIssueModel> items) {
                        return isDetailedViewMode
                            ? _IssuesList(issues: items)
                            : IssuesGalleryBuilder(issues: items);
                      },
                    );
                  },
                ),
              ),
              OnGoingBottomWidget(provider: issuesProvider),
            ],
          ),
        );
      },
      error: (err, stack) {
        return renderCarrotErrorWidget(ref);
      },
      loading: () => const SizedBox(),
    );
  }
}

class _IssuesList extends StatelessWidget {
  final List<ComicIssueModel> issues;
  const _IssuesList({
    required this.issues,
  });
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: issues.length,
      shrinkWrap: true,
      physics: const PageScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return ComicIssueCardLarge(
          issue: issues[index],
        );
      },
    );
  }
}
