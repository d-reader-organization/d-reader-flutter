import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SortMenu extends StatelessWidget {
  const SortMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset('assets/icons/swap.svg'),
            const SizedBox(
              width: 8,
            ),
            const Text(
              'Sort By',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        )
      ],
    );
  }
}
