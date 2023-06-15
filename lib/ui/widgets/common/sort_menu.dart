import 'package:d_reader_flutter/ui/widgets/common/buttons/radio_button.dart';
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
        ),
        Column(
          children: const [
            FilterRadioButton(
              title: 'Rating',
              value: SortByEnum.rating,
            ),
            FilterRadioButton(
              title: 'Likes',
              value: SortByEnum.likes,
            ),
            FilterRadioButton(
              title: 'Readers',
              value: SortByEnum.readers,
            ),
            FilterRadioButton(
              title: 'Viewers',
              value: SortByEnum.viewers,
            ),
          ],
        ),
      ],
    );
  }
}
