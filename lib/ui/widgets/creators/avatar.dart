import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/cover_cached_image.dart';
import 'package:flutter/material.dart';

class CreatorAvatar extends StatelessWidget {
  final String avatar;
  const CreatorAvatar({
    super.key,
    required this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 64,
      backgroundColor: dReaderDarkGrey,
      child: CommonCachedImage(
        imageUrl: avatar,
        fit: BoxFit.scaleDown,
      ),
    );
  }
}
