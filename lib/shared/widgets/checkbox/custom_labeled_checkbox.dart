import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomLabeledCheckbox extends StatelessWidget {
  final bool isChecked;
  final void Function() onChange;
  final Widget label;

  const CustomLabeledCheckbox({
    super.key,
    required this.isChecked,
    required this.onChange,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChange();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Transform.scale(
              scale: 1.2,
              child: Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                ),
                side: const BorderSide(
                  width: 1.0,
                  color: ColorPalette.greyscale300,
                ),
                value: isChecked,
                fillColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) =>
                      !states.contains(MaterialState.selected)
                          ? ColorPalette.greyscale500
                          : ColorPalette.dReaderYellow100,
                ),
                checkColor: Colors.black,
                activeColor: ColorPalette.dReaderYellow100,
                onChanged: (value) {
                  onChange();
                },
              ),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          label,
        ],
      ),
    );
  }
}
