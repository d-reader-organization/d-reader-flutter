import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/core/providers/genre_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/justify_color_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GenreFilter extends ConsumerWidget {
  final GenreModel genre;
  const GenreFilter({
    Key? key,
    required this.genre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final selectedGenres = ref.read(selectedGenresProvider);
        final notifer = ref.read(selectedGenresProvider.notifier);
        if (selectedGenres.contains(genre.slug)) {
          selectedGenres.remove(genre.slug);
        } else {
          selectedGenres.add(genre.slug);
        }

        notifer.update((state) => [...selectedGenres]);
      },
      child: Container(
        height: 87,
        width: 85,
        decoration: BoxDecoration(
          color: ref.watch(selectedGenresProvider).contains(genre.slug)
              ? getColorFromGenreString(genre.color)
              : null,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ColorPalette.boxBackground300),
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