import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';

class WalkthroughDialog extends StatelessWidget {
  final Function() onSubmit;
  final String assetPath, buttonText, title, subtitle;
  final Widget? bottomWidget;
  const WalkthroughDialog({
    super.key,
    required this.onSubmit,
    required this.assetPath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(
        16,
      ),
      backgroundColor: ColorPalette.greyscale400,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          8,
        ),
      ),
      children: [
        if (assetPath.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              assetPath,
            ),
          ),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ColorPalette.greyscale50,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        CustomTextButton(
          onPressed: onSubmit,
          borderRadius: BorderRadius.circular(8),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        if (bottomWidget != null) ...[
          const SizedBox(
            height: 8,
          ),
          bottomWidget!,
        ],
      ],
    );
  }
}
