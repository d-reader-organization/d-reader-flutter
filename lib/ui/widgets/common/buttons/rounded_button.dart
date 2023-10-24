import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final void Function()? onPressed;
  final Size size;
  final double fontSize;
  final bool isLoading, isDisabled;
  final Color borderColor;
  final double padding;
  final TextStyle textStyle;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = ColorPalette.dReaderYellow100,
    this.textColor = ColorPalette.appBackgroundColor,
    this.size = const Size(120, 27),
    this.fontSize = 14,
    this.isLoading = false,
    this.isDisabled = false,
    this.borderColor = Colors.transparent,
    this.padding = 8,
    this.textStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: TextButton(
        onPressed: isLoading || isDisabled ? null : onPressed,
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
                color: ColorPalette.greyscale500,
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
                style: textStyle,
              ),
      ),
    );
  }
}
