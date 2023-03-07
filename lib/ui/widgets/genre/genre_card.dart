import 'package:d_reader_flutter/core/models/genre.dart';
import 'package:d_reader_flutter/ui/utils/justify_color_string.dart';
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
    return Container(
      height: 90,
      width: 85,
      margin: const EdgeInsets.only(right: 24),
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
    );
  }
}
