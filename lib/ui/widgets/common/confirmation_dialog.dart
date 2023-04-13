import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  const ConfirmationDialog({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorPalette.boxBackground300,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        RoundedButton(
          text: 'Cancel',
          backgroundColor: ColorPalette.boxBackground400,
          textColor: Colors.white,
          onPressed: () {
            return Navigator.pop(context, false);
          },
        ),
        RoundedButton(
          text: 'Yes',
          onPressed: () {
            return Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
