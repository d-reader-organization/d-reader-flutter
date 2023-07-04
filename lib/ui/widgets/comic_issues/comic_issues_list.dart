import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/ui/utils/home_cards_width.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_issue_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComicIssuesList extends ConsumerWidget {
  final String? query;
  final bool onlyFree;
  const ComicIssuesList({
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
            ? SizedBox(
                height: 276,
                child: ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return ComicIssueCard(
                      issue: data[index],
                    );
                  },
                ),
              )
            : const Text('No issues found.');
      },
      error: (err, stack) => Text(
        'Error: $err',
        style: const TextStyle(color: Colors.red),
      ),
      loading: () => SizedBox(
        height: 276,
        child: ListView.builder(
          itemCount: 2,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => SkeletonCard(
            height: 276,
            width: getCardWidth(MediaQuery.sizeOf(context).width),
          ),
        ),
      ),
    );
  }
}
