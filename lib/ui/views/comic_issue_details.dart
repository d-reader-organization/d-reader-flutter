import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/details_scaffold_model.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/ui/widgets/details_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComicIssueDetails extends ConsumerWidget {
  final int id;
  const ComicIssueDetails({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ComicIssueModel?> provider =
        ref.watch(comicIssueDetailsProvider(id));
    return provider.when(
      data: (issue) {
        if (issue == null) {
          return const SizedBox();
        }
        return DetailsScaffold(
          isComicDetails: false,
          detailsScaffoldModel: DetailsScaffoldModel(
              slug: issue.slug,
              imageUrl: issue.cover,
              description: issue.description,
              title: issue.comic?.name ?? '',
              subtitle: issue.title,
              avatarUrl: issue.creator.avatar,
              creatorSlug: issue.creator.slug,
              authorName: issue.creator.name,
              favouriteStats: FavouriteStats(
                count: 5,
                isFavourite: true,
              ),
              episodeNumber: issue.number,
              generalStats: GeneralStats(
                totalIssuesCount: issue.stats!.totalIssuesCount,
                totalVolume: issue.stats!.totalVolume,
                floorPrice: issue.stats!.floorPrice,
                totalSupply: issue.stats!.totalSupply,
              ),
              releaseDate: issue.releaseDate),
          body: const SizedBox(), // TO DO READ ISSUE BUTTON PLUS CARDS
        );
      },
      error: (err, stack) {
        print(stack);
        return Text(
          'Error: $err',
          style: const TextStyle(color: Colors.red),
        );
      },
      loading: () => const SizedBox(),
    );
  }
}
