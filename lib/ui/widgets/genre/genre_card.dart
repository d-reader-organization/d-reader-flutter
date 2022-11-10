import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/justifyColorString.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GenreCard extends StatelessWidget {
  final GenreModel genre;
  const GenreCard({
    Key? key,
    required this.genre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color genreColor = Color(
      int.parse('0xFF${justifyColorString(genre.color)}'),
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
          SvgPicture.network(genre.icon, color: genreColor),
          Text(
            genre.name,
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
