import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/justifyColorString.dart';
import 'package:flutter/material.dart';

class GenreCard extends StatelessWidget {
  final String title;
  final String color;
  const GenreCard({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color genreColor = Color(
      int.parse('0xFF${justifyColorString(color)}'),
    );
    return Container(
      height: 90,
      width: 85,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: dReaderDarkGrey,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(width: 0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.star_outline,
            color: genreColor,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: genreColor),
          ),
        ],
      ),
    );
  }
}
