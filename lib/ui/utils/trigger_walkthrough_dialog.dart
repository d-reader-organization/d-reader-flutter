import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:d_reader_flutter/ui/widgets/common/dialogs/walkthrough_dialog.dart';
import 'package:flutter/material.dart';

triggerWalkthroughDialogIfNeeded({
  required BuildContext context,
  required String key,
  required String title,
  required String subtitle,
  required String assetPath,
  required Function() onSubmit,
  Widget? bottomWidget,
}) {
  final localStore = LocalStore.instance;
  final isAlreadyshown = localStore.get(key) != null;
  if (!isAlreadyshown) {
    return Future.delayed(
      const Duration(milliseconds: 850),
      () {
        return triggerWalkthroughDialog(
          context: context,
          title: title,
          subtitle: subtitle,
          assetPath: assetPath,
          bottomWidget: bottomWidget,
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
  required String assetPath,
  String buttonText = 'Got it!',
  Widget? bottomWidget,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return WalkthroughDialog(
        onSubmit: onSubmit,
        assetPath: assetPath,
        title: title,
        subtitle: subtitle,
        bottomWidget: bottomWidget,
        buttonText: buttonText,
      );
    },
  );
}

triggerLowPowerModeDialog(BuildContext context) {
  return triggerWalkthroughDialog(
    context: context,
    assetPath: '$walkthroughAssetsPath/power_saving.jpg',
    title: 'Turn off power saving',
    subtitle:
        'Your device is in low power mode. Deactivate it to enable connection and signing',
    onSubmit: () {
      Navigator.pop(context);
    },
  );
}
