import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor, borderColor, loadingColor, textColor;
  final void Function()? onPressed;
  final Size size;
  final double fontSize;
  final bool isLoading, isDisabled;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;

  const CustomTextButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor = ColorPalette.dReaderYellow100,
    this.textColor = ColorPalette.appBackgroundColor,
    this.size = const Size(120, 27),
    this.fontSize = 14,
    this.isLoading = false,
    this.isDisabled = false,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(
        8,
      ),
    ),
    this.padding = const EdgeInsets.all(8),
    this.borderColor = Colors.transparent,
    this.loadingColor = ColorPalette.appBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextButton(
        onPressed: isDisabled
            ? null
            : () {
                if (isLoading) {
                  return;
                }
                if (onPressed != null) {
                  onPressed!();
                }
              },
        style: TextButton.styleFrom(
          minimumSize: size,
          backgroundColor: backgroundColor,
          disabledBackgroundColor: ColorPalette.dReaderGrey,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
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
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: loadingColor),
              )
            : child,
      ),
    );
  }
}
