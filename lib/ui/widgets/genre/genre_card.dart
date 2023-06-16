import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/core/providers/genre_provider.dart';
import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/core/providers/tab_bar_provider.dart';
import 'package:d_reader_flutter/ui/utils/justify_color_string.dart';
import 'package:d_reader_flutter/ui/views/discover.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GenreCard extends ConsumerWidget {
  final GenreModel genre;
  const GenreCard({
    Key? key,
    required this.genre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedGenresProvider.notifier).update(
              (state) => [genre.slug],
            );
        ref.read(tabBarProvider.notifier).setTabIndex(
              DiscoverTabViewEnum.comics.index,
            );
        ref.read(scaffoldProvider.notifier).setNavigationIndex(1);
        ref.read(scaffoldPageController).animateToPage(
              1,
              curve: Curves.linear,
              duration: const Duration(milliseconds: 350),
            );
      },
      child: Container(
        height: 90,
        width: 85,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: getColorFromGenreString(genre.color),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(width: 0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.network(
              genre.icon,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              width: 32,
              height: 32,
            ),
            Text(
              genre.name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
