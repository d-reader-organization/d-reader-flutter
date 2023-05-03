import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_issue_card_large.dart';
import 'package:d_reader_flutter/ui/widgets/comics/details/scaffold.dart';
import 'package:d_reader_flutter/ui/widgets/discover/common/on_going_bottom.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ComicDetails extends ConsumerWidget {
  final String slug;
  const ComicDetails({
    Key? key,
    required this.slug,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ComicModel?> provider = ref.watch(comicSlugProvider(slug));
    final issuesProvider =
        ref.watch(paginatedIssuesProvider('comicSlug=$slug'));

    return provider.when(
      data: (comic) {
        if (comic == null) {
          return const SizedBox();
        }
        return ComicDetailsScaffold(
          comic: comic,
          loadMore: ref
              .read(
                paginatedIssuesProvider('comicSlug=$slug').notifier,
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
                        return _IssuesList(issues: issues);
                      },
                      error: (Object? e, StackTrace? stk) {
                        Sentry.captureException(e, stackTrace: stk);
                        return const Text('Something Went Wrong.');
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
