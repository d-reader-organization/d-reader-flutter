import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/tabs/cards/comic_issue_card.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComicIssuesList extends ConsumerWidget {
  final String? query;

  const ComicIssuesList({
    super.key,
    this.query,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ComicIssueModel>> comicIssues =
        ref.watch(comicIssuesProvider(query));
    final screenWidth = MediaQuery.sizeOf(context).width;
    return comicIssues.when(
      data: (data) {
        return data.isNotEmpty
            ? SizedBox(
                height: 227,
                child: ListView.builder(
                  itemCount: data.length,
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
          style: TextStyle(color: ColorPalette.dReaderRed),
        );
      },
      loading: () => SizedBox(
        height: 227,
        child: ListView.builder(
          itemCount: 3,
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
