import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class TextWithViewMore extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final int maxLines;
  final Function()? onLinkTap;
  const TextWithViewMore({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.maxLines = 2,
    this.onLinkTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ExpandableText(
      text,
      maxLines: maxLines,
      expandText: 'view more',
      collapseText: 'view less',
      onLinkTap: onLinkTap,
      linkEllipsis: false,
      linkStyle: textTheme.bodyMedium?.copyWith(
        color: ColorPalette.dReaderYellow100,
      ),
      style: textTheme.bodyMedium,
    );
  }
}
