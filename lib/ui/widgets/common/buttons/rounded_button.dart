import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final void Function()? onPressed;
  final Size size;
  final double fontSize;
  final bool isLoading;
  final Color borderColor;

  const RoundedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = ColorPalette.dReaderYellow100,
    this.textColor = ColorPalette.appBackgroundColor,
    this.size = const Size(120, 27),
    this.fontSize = 14,
    this.isLoading = false,
    this.borderColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          minimumSize: size,
          disabledBackgroundColor: ColorPalette.dReaderGrey,
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(
                8,
              ),
            ),
            side: BorderSide(
              color: borderColor,
            ),
          ),
          foregroundColor: textColor,
          textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: ColorPalette.boxBackground200,
                fontWeight: FontWeight.w700,
                fontSize: fontSize,
              ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 32,
                width: 32,
                child: CircularProgressIndicator(
                  color: ColorPalette.appBackgroundColor,
                ),
              )
            : Text(
                text,
              ),
      ),
    );
  }
}
