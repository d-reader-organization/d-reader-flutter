import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/ui/widgets/comics/comic_card_large.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreatorComicsTab extends ConsumerWidget {
  final String creatorSlug;
  const CreatorComicsTab({
    super.key,
    required this.creatorSlug,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ComicModel>> provider =
        ref.watch(comicsProvider('creatorSlug=$creatorSlug'));

    return provider.when(
      data: (comics) {
        return ListView.builder(
          itemCount: comics.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(top: 24),
              child: ComicCardLarge(
                comic: comics[index],
              ),
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
