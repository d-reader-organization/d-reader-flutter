import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/ui/utils/append_default_query_string.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_issue_card_large.dart';
import 'package:d_reader_flutter/ui/widgets/comics/details/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComicDetails extends ConsumerWidget {
  final String slug;
  const ComicDetails({
    Key? key,
    required this.slug,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ComicModel?> provider = ref.watch(comicSlugProvider(slug));
    final AsyncValue<List<ComicIssueModel>> issuesProvider = ref.watch(
      comicIssuesProvider(
        appendDefaultQuery('comicSlug=$slug'),
      ),
    );
    return provider.when(
      data: (comic) {
        if (comic == null) {
          return const SizedBox();
        }
        return ComicDetailsScaffold(
          body: ListView.builder(
            itemCount: issuesProvider.value?.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const PageScrollPhysics(),
            itemBuilder: (context, index) {
              return issuesProvider.value?[index] != null
                  ? ComicIssueCardLarge(
                      issue: issuesProvider.value![index],
                    )
                  : const SizedBox();
            },
          ),
          comic: comic,
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
