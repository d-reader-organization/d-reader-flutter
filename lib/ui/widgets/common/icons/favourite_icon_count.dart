import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavouriteIconCount extends StatelessWidget {
  final int favouritesCount;
  const FavouriteIconCount({
    Key? key,
    required this.favouritesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        const Icon(
          CupertinoIcons.heart,
          color: ColorPalette.dReaderGrey,
          size: 16,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          favouritesCount.toString(),
          style: textTheme.labelMedium,
        ),
      ],
    );
  }
}
