import 'dart:io' show Platform;

import 'package:d_reader_flutter/core/providers/check_for_app_version_provider.dart';
import 'package:d_reader_flutter/ui/widgets/d_reader_scaffold.dart';
import 'package:flutter/widgets.dart';
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
                upgrader: Upgrader(
                  canDismissDialog: true,
                  showReleaseNotes: false,
                  debugDisplayOnce: true,
                  durationUntilAlertAgain: const Duration(
                    days: 3,
                  ),
                  dialogStyle: Platform.isIOS
                      ? UpgradeDialogStyle.cupertino
                      : UpgradeDialogStyle.material,
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
