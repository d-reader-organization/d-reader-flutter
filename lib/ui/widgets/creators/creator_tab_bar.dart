import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class CreatorTabBar extends StatelessWidget with PreferredSizeWidget {
  final List<Widget> children;
  const CreatorTabBar({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: dReaderSome, width: 2.0),
              ),
            ),
          ),
          TabBar(
            tabs: children,
            indicatorWeight: 4,
            indicatorColor: dReaderYellow,
            labelColor: dReaderYellow,
          ),
        ],
      ),
    );
  }
}
