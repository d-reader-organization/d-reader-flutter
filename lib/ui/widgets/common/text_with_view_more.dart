import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class TextWithViewMore extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final int maxLines;

  const TextWithViewMore({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.maxLines = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableText(
      text,
      maxLines: 2,
      expandText: 'view more',
      collapseText: 'view less',
      linkEllipsis: false,
      linkStyle:
          const TextStyle(fontSize: 16, color: ColorPalette.dReaderYellow100),
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
    );
  }
}
