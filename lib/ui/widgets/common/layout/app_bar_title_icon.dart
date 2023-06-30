import 'package:d_reader_flutter/ui/widgets/common/test_mode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarTitleIcon extends StatelessWidget {
  final bool isDevnet;
  final String iconPath, title;
  const AppBarTitleIcon({
    super.key,
    required this.isDevnet,
    required this.iconPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TestModeWidget(),
        AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SvgPicture.asset(
                iconPath,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
