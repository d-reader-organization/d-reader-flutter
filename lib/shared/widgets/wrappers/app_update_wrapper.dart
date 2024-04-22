import 'dart:io' show Platform;

import 'package:d_reader_flutter/shared/presentations/providers/app_version/check_for_app_version_provider.dart';
import 'package:d_reader_flutter/shared/widgets/scaffolds/d_reader_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:upgrader/upgrader.dart';

class AppUpdateWrapper extends ConsumerWidget {
  const AppUpdateWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(shouldTriggerAppVersionUpdateProvider).when(
      data: (shouldTriggerUpdateDialog) {
        return shouldTriggerUpdateDialog
            ? UpgradeAlert(
                barrierDismissible: true,
                showReleaseNotes: false,
                dialogStyle: Platform.isIOS
                    ? UpgradeDialogStyle.cupertino
                    : UpgradeDialogStyle.material,
                upgrader: Upgrader(
                  debugDisplayOnce: true,
                  durationUntilAlertAgain: const Duration(
                    days: 3,
                  ),
                ),
                child: const DReaderScaffold(),
              )
            : const DReaderScaffold();
      },
      error: (error, stackTrace) {
        return const DReaderScaffold();
      },
      loading: () {
        return const DReaderScaffold();
      },
    );
  }
}
