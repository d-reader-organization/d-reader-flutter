import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SettingsButtonsBottom extends StatelessWidget {
  final bool isLoading;
  final Function() onCancel;
  final Function() onSave;

  const SettingsButtonsBottom({
    super.key,
    required this.isLoading,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextButton(
              size: const Size(double.infinity, 40),
              onPressed: onCancel,
              borderRadius: BorderRadius.circular(8),
              backgroundColor: Colors.transparent,
              textColor: const Color(0xFFEBEDF3),
              borderColor: const Color(0xFFEBEDF3),
              child: const Text('Cancel'),
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
                  child: const Text('Save'),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
