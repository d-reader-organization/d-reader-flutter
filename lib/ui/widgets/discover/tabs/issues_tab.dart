import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/search_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/discover/comic_issue_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiscoverIssuesTab extends ConsumerWidget {
  const DiscoverIssuesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String search = ref.watch(searchProvider).search;
    AsyncValue<List<ComicIssueModel>> provider =
        ref.watch(comicIssuesProvider('titleSubstring=$search'));
    return provider.when(
      data: (issues) {
        return issues.isNotEmpty
            ? ListView.separated(
                itemCount: issues.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return DiscoverComicIssueCard(
                    issue: issues[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    color: ColorPalette.boxBackground300,
                  );
                },
              )
            : Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  'No results found',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
      },
      error: (err, stack) => Text(
        'Error: $err',
        style: const TextStyle(color: Colors.red),
      ),
      loading: () => SizedBox(
        height: 90,
        child: ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          itemBuilder: (context, index) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: SkeletonCard(),
          ),
        ),
      ),
    );
  }
}
