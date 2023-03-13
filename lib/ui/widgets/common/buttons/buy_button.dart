import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class BuyButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color textColor;
  final void Function() onPressed;
  final Size size;
  final double fontSize;
  final bool isLoading;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry padding;

  const BuyButton(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.backgroundColor = ColorPalette.dReaderYellow100,
      this.textColor = ColorPalette.appBackgroundColor,
      this.size = const Size(120, 27),
      this.fontSize = 14,
      this.isLoading = false,
      this.borderRadius = const BorderRadius.all(
        Radius.circular(
          32,
        ),
      ),
      this.padding = const EdgeInsets.all(8)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          minimumSize: size,
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
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
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: ColorPalette.appBackgroundColor,
                ),
              )
            : child,
      ),
    );
  }
}
