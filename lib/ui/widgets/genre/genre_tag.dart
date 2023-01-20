import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/justify_color_string.dart';
import 'package:flutter/material.dart';

class GenreTag extends StatelessWidget {
  final String color;
  final String name;
  const GenreTag({
    Key? key,
    required this.color,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return name.isNotEmpty
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: getColorFromGenreString(color),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          )
        : const EmptyGenreTag();
  }
}

class EmptyGenreTag extends StatelessWidget {
  const EmptyGenreTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: ColorPalette.boxBackground400, width: 1)),
      child: const Icon(
        Icons.more_horiz_outlined,
        color: ColorPalette.boxBackground400,
        size: 15,
      ),
    );
  }
}
