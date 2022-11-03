import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class GenreCard extends StatelessWidget {
  final String title;
  const GenreCard({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 85,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: dReaderDarkGrey,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(width: 0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Icon(
            Icons.star_outline,
            color: Colors.white,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
