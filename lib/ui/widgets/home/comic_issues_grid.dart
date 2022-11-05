import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/ui/widgets/home/comic_issue_card.dart';
import 'package:d_reader_flutter/ui/widgets/home/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComicIssuesGrid extends ConsumerWidget {
  const ComicIssuesGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ComicIssueModel>> comicIssues =
        ref.watch(comicIssueProvider);
    return comicIssues.when(
      data: (data) {
        return GridView.builder(
          primary: false,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            mainAxisExtent: 255,
          ),
          itemBuilder: (context, index) {
            return ComicIssueCard(
              title: data[index].title,
              description: data[index].description,
              price: 0.865,
            );
          },
          itemCount: data.length > 4 ? 4 : data.length,
        );
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
