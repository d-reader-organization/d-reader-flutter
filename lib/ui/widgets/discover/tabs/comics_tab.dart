import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/discover/comic_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiscoverComicsTab extends ConsumerWidget {
  const DiscoverComicsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<ComicModel>> provider = ref.watch(comicsProvider);
    return provider.when(
      data: (comics) {
        return comics.isNotEmpty
            ? ListView.separated(
                itemCount: comics.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return DiscoverComicCard(
                    comic: comics[index],
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
          itemBuilder: (context, index) => const SkeletonCard(),
        ),
      ),
    );
  }
}
