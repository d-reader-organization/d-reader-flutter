import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
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
          height: 255,
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
        height: 240,
        child: ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => const SkeletonCard(
            margin: EdgeInsets.only(right: 16),
          ),
        ),
      ),
    );
  }
}
