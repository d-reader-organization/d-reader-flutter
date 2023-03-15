import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_issue_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComicIssuesGrid extends ConsumerWidget {
  final String? query;
  final bool onlyFree;
  const ComicIssuesGrid({
    Key? key,
    this.query,
    this.onlyFree = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ComicIssueModel>> comicIssues =
        ref.watch(comicIssuesProvider(query));
    return comicIssues.when(
      data: (data) {
        if (onlyFree) {
          data = data.where((element) => element.isFree).toList();
        }
        return data.isNotEmpty
            ? GridView.builder(
                primary: false,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 255,
                ),
                itemBuilder: (context, index) {
                  return ComicIssueCard(
                    issue: data[index],
                  );
                },
                itemCount: data.length > 4 ? 4 : data.length,
              )
            : Text('No ${onlyFree ? 'free' : 'popular'} issues');
      },
      error: (err, stack) => Text(
        'Error: $err',
        style: const TextStyle(color: Colors.red),
      ),
      loading: () => SizedBox(
        height: 90,
        child: ListView.builder(
          itemCount: 2,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => const SkeletonCard(),
        ),
      ),
    );
  }
}
