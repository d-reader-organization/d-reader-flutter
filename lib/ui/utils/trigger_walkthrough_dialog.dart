import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:d_reader_flutter/ui/widgets/common/dialogs/walkthrough_dialog.dart';
import 'package:flutter/material.dart';

triggerWalkthroughDialogIfNeeded({
  required BuildContext context,
  required String key,
  required String title,
  required String subtitle,
  required Function() onSubmit,
}) {
  final localStore = LocalStore.instance;
  final isAlreadyshown = localStore.get(key) != null;
  if (!isAlreadyshown) {
    Future.delayed(
      const Duration(milliseconds: 850),
      () {
        triggerWalkthroughDialog(
          context: context,
          title: title,
          subtitle: subtitle,
          onSubmit: () {
            localStore.put(key, true);
            onSubmit();
          },
        );
      },
    );
  }
}

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
