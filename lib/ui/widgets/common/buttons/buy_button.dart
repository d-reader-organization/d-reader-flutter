import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class BuyButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const BuyButton({
    Key? key,
    required this.text,
    this.backgroundColor = ColorPalette.dReaderYellow100,
    this.textColor = ColorPalette.appBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        minimumSize: const Size(55, 22),
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              8,
            ),
          ),
        ),
        foregroundColor: textColor,
        textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: ColorPalette.boxBackground200,
            fontWeight: FontWeight.w700,
            fontSize: 11),
      ),
      child: Text(text),
    );
  }
}
