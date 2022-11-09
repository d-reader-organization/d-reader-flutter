import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class GenreRectangle extends StatelessWidget {
  final Color color;
  final String title;
  const GenreRectangle(
      {Key? key, required this.title, this.color = dReaderDarkGrey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.only(right: 4),
      height: 18,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFD9D9D9),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
