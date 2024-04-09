import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/tabs/cards/comic_issue_card.dart';
import 'package:d_reader_flutter/shared/widgets/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComicIssuesList extends ConsumerWidget {
  final String? query;
  final bool onlyFree;

  const ComicIssuesList({
    super.key,
    this.query,
    this.onlyFree = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ComicIssueModel>> comicIssues =
        ref.watch(comicIssuesProvider(query));
    final screenWidth = MediaQuery.sizeOf(context).width;
    return comicIssues.when(
      data: (data) {
        if (onlyFree) {
          data = data.where((element) => element.isFreeToRead).toList();
        }
        return data.isNotEmpty
            ? SizedBox(
                height: 227,
                child: ListView.builder(
                  itemCount: data.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      width: screenWidth > 360 ? 156 : 152,
                      margin: const EdgeInsets.only(right: 16),
                      child: ComicIssueCard(
                        issue: data[index],
                      ),
                    );
                  },
                ),
              )
            : const Text('No issues found.');
      },
      error: (err, stack) {
        return const Text(
          "Fetch data error occured.",
          style: TextStyle(color: Colors.red),
        );
      },
      loading: () => SizedBox(
        height: 227,
        child: ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => SkeletonCard(
            margin: const EdgeInsets.only(
              right: 16,
            ),
            width: screenWidth > 360 ? 156 : 152,
          ),
        ),
      ),
    );
  }
}
