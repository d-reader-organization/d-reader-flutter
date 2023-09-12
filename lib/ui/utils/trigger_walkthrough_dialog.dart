import 'package:d_reader_flutter/ui/widgets/common/dialogs/walkthrough_dialog.dart';
import 'package:flutter/material.dart';

triggerWalkthroughDialog(
    {required BuildContext context, required Function() onSubmit}) {
  return showDialog(
    context: context,
    builder: (context) {
      return WalkthroughDialog(
        onSubmit: onSubmit,
      );
    },
  );
}
