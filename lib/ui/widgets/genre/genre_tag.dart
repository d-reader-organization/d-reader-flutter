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
    return Container(
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
    );
  }
}
