import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/ui/utils/home_cards_width.dart';
import 'package:d_reader_flutter/ui/widgets/comics/comic_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComicsListView extends ConsumerWidget {
  final String? query;
  const ComicsListView({
    Key? key,
    this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ComicModel>> comics = ref.watch(comicsProvider(query));
    return comics.when(
      data: (data) {
        if (data.isEmpty) {
          return const SizedBox();
        }
        return SizedBox(
          height: 276,
          child: ListView.builder(
            itemCount: data.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => ComicCard(
              comic: data[index],
            ),
          ),
        );
      },
      error: (err, stack) => Text(
        'Error: $err',
        style: const TextStyle(color: Colors.red),
      ),
      loading: () => SizedBox(
        height: 276,
        child: ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => SkeletonCard(
            margin: const EdgeInsets.only(right: 16),
            width: getCardWidth(MediaQuery.sizeOf(context).width),
            height: 276,
          ),
        ),
      ),
    );
  }
}
