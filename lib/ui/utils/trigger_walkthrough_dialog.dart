import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/user/domain/providers/user_provider.dart';
import 'package:d_reader_flutter/shared/data/local/local_store.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/dialogs/walkthrough_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show WidgetRef;

triggerWalkthroughDialogIfNeeded({
  required BuildContext context,
  required String key,
  required String title,
  required String subtitle,
  required String assetPath,
  required Function() onSubmit,
  int durationInMiliseconds = 850,
  Widget? bottomWidget,
}) {
  final localStore = LocalStore.instance;
  final isAlreadyshown = localStore.get(key) != null;
  if (!isAlreadyshown) {
    return Future.delayed(
      Duration(milliseconds: durationInMiliseconds),
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

void triggerWalkthroughDialog({
  required BuildContext context,
  required Function() onSubmit,
  required String title,
  required String subtitle,
  required String assetPath,
  String buttonText = 'Got it!',
  Widget? bottomWidget,
}) async {
  return await showDialog(
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

void triggerLowPowerModeDialog(BuildContext context) {
  return triggerWalkthroughDialog(
    context: context,
    assetPath: '$walkthroughAssetsPath/power_saving.jpg',
    title: 'Turn off power saving',
    subtitle:
        'Your device is in low power mode. Deactivate it to enable connection and signing',
    onSubmit: () {
      context.pop();
    },
  );
}

void triggerVerificationDialog(BuildContext context, WidgetRef ref) {
  return triggerWalkthroughDialog(
    context: context,
    title: 'Verify your email',
    subtitle:
        'This sale is currently only available for new verified users. To become eligible make sure to verify your email. Don\'t forget to check your spam!',
    assetPath: '$walkthroughAssetsPath/verify_email.jpg',
    onSubmit: () {
      ref.read(userRepositoryProvider).requestEmailVerification();
      context.pop();
      showSnackBar(
        context: context,
        text: 'Verification email has been sent.',
        backgroundColor: ColorPalette.dReaderGreen,
      );
    },
  );
}
