import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/ui/utils/home_cards_width.dart';
import 'package:d_reader_flutter/ui/widgets/comics/comic_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComicsListView extends ConsumerWidget {
  final String? query;

  const ComicsListView({
    super.key,
    this.query,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ComicModel>> comics = ref.watch(comicsProvider(query));
    return comics.when(
      data: (data) {
        if (data.isEmpty) {
          return const Text(
            'No comics.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          );
        }
        return SizedBox(
          height: 226,
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
      error: (err, stack) {
        return const Text(
          "Couldn't fetch the data",
          style: TextStyle(color: Colors.red),
        );
      },
      loading: () => SizedBox(
        height: 226,
        child: ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => SkeletonCard(
            margin: const EdgeInsets.only(right: 16),
            width: getCardWidth(MediaQuery.sizeOf(context).width),
            height: 226,
          ),
        ),
      ),
    );
  }
}
