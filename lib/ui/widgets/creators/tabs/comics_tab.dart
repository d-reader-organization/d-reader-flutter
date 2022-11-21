import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/ui/widgets/comics/comic_card_large.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatorComicsTab extends ConsumerWidget {
  const CreatorComicsTab({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ComicModel>> comicsProvider = ref.watch(comicProvider);

    return comicsProvider.when(
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
          style: TextStyle(color: Colors.red),
        );
      },
      loading: () => ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => const SkeletonCard(),
      ),
    );
  }
}
