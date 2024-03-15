import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/discover/root/presentations/providers/filter_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_issue_card_large.dart';
import 'package:d_reader_flutter/ui/widgets/comics/details/scaffold.dart';
import 'package:d_reader_flutter/ui/widgets/discover/common/on_going_bottom.dart';
import 'package:d_reader_flutter/ui/widgets/discover/tabs/issues/issues_gallery_builder.dart';
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
    final AsyncValue<ComicModel?> provider = ref.watch(comicSlugProvider(slug));
    final issuesProvider = ref.watch(
      paginatedIssuesProvider(
        'comicSlug=$slug&sortTag=latest&sortOrder=${getSortDirection(ref.watch(comicSortDirectionProvider))}',
      ),
    );

    return provider.when(
      data: (comic) {
        if (comic == null) {
          return const SizedBox();
        }
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
                        return ref.watch(comicViewModeProvider) ==
                                ViewMode.detailed
                            ? _IssuesList(issues: issues)
                            : IssuesGalleryBuilder(
                                issues: issues,
                              );
                      },
                      error: (Object? e, StackTrace? stk) {
                        return const Text('Failed to fetch data.');
                      },
                      loading: () {
                        return const SizedBox();
                      },
                      onGoingError: (List<ComicIssueModel> items, Object? e,
                          StackTrace? stk) {
                        return _IssuesList(issues: items);
                      },
                      onGoingLoading: (List<ComicIssueModel> items) {
                        return _IssuesList(issues: items);
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
      error: (err, stack) => Text(
        'Error: $err',
        style: const TextStyle(color: Colors.red),
      ),
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
