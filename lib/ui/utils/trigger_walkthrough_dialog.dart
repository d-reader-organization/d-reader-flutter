import 'package:d_reader_flutter/ui/widgets/common/dialogs/walkthrough_dialog.dart';
import 'package:flutter/material.dart';

triggerWalkthroughDialog({
  required BuildContext context,
  required Function() onSubmit,
  required String title,
  required String subtitle,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return WalkthroughDialog(
        onSubmit: onSubmit,
        title: title,
        subtitle: subtitle,
      );
    },
  );
}
