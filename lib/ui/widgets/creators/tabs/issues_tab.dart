import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_issue_card_large.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreatorIssuesTab extends ConsumerWidget {
  final String creatorSlug;
  const CreatorIssuesTab({
    super.key,
    required this.creatorSlug,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ComicIssueModel>> provider =
        ref.watch(comicIssuesProvider('creatorSlug=$creatorSlug'));

    return provider.when(
      data: (issues) {
        return ListView.builder(
          itemCount: issues.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ComicIssueCardLarge(
              issue: issues[index],
            );
          },
        );
      },
      error: (err, stack) {
        return Text(
          '$err',
          style: const TextStyle(color: Colors.red),
        );
      },
      loading: () => ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => const SkeletonCard(),
      ),
    );
  }
}
