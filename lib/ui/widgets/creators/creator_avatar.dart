import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class CreatorAvatar extends StatelessWidget {
  const CreatorAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 64,
      backgroundColor: dReaderDarkGrey,
      child: Icon(
        Icons.person,
        color: dReaderYellow,
        size: 48,
      ),
    );
  }
}
