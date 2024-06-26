import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsButtonsBottom extends StatelessWidget {
  final bool isLoading;
  final String cancelText, confirmText;
  final Function() onCancel, onSave;

  const SettingsButtonsBottom({
    super.key,
    required this.isLoading,
    this.cancelText = 'Cancel',
    this.confirmText = 'Save',
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            Expanded(
              child: CustomTextButton(
                size: const Size(double.infinity, 40),
                onPressed: onCancel,
                borderRadius: BorderRadius.circular(8),
                backgroundColor: Colors.transparent,
                textColor: ColorPalette.greyscale50,
                borderColor: ColorPalette.greyscale50,
                child: Text(cancelText),
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                return Expanded(
                  child: CustomTextButton(
                    isLoading: isLoading,
                    size: const Size(double.infinity, 40),
                    onPressed: onSave,
                    borderRadius: BorderRadius.circular(8),
                    child: Text(confirmText),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
