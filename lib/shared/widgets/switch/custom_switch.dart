import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final String title;
  final bool isTurnedOn;
  final void Function() onChange;

  const CustomSwitch({
    super.key,
    required this.title,
    required this.isTurnedOn,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        Switch(
          thumbColor: MaterialStateProperty.resolveWith((states) {
            return Colors.white;
          }),
          trackOutlineColor: const MaterialStatePropertyAll(Colors.transparent),
          trackColor: MaterialStateProperty.resolveWith((states) {
            return states.contains(MaterialState.selected)
                ? ColorPalette.dReaderGreen
                : ColorPalette.greyscale300;
          }),
          value: isTurnedOn,
          onChanged: (value) {
            onChange();
          },
        )
      ],
    );
  }
}
