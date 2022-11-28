import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/details_scaffold_model.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_issue_card_large.dart';
import 'package:d_reader_flutter/ui/widgets/details_scaffold.dart';
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
      comicIssuesByQueryParam(
        'comicSlug=$slug',
      ),
    );
    return provider.when(
      data: (comic) {
        if (comic == null) {
          return const SizedBox();
        }
        return DetailsScaffold(
          isComicDetails: true,
          detailsScaffoldModel: DetailsScaffoldModel(
            slug: comic.slug,
            imageUrl: comic.cover,
            description: comic.description,
            title: comic.name,
            subtitle: comic.flavorText,
            avatarUrl: comic.creator.avatar,
            creatorSlug: comic.creator.slug,
            authorName: comic.creator.name,
            genres: comic.genres,
            flavorText: comic.flavorText,
            favouriteStats: FavouriteStats(
              count: comic.stats?.favouritesCount ?? 0,
              isFavourite: comic.myStats?.isFavourite ?? false,
            ),
            generalStats: GeneralStats(
              totalVolume: comic.stats!.totalVolume,
              readersCount: comic.stats!.readersCount,
              totalIssuesCount: comic.stats!.issuesCount,
              averageRating: comic.stats!.averageRating,
              isPopular: comic.isPopular,
            ),
          ),
          body: ListView.builder(
            itemCount: issuesProvider.value?.length,
            itemBuilder: (context, index) {
              return ComicIssueCardLarge(
                issue: issuesProvider.value![index],
              );
            },
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
