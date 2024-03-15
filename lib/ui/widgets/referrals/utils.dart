import 'package:d_reader_flutter/features/settings/presentations/providers/referral.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

handleSave(BuildContext context, WidgetRef ref, String referrer) async {
  await ref.read(referralControllerProvider.notifier).handleSave(
        referrer: referrer,
        callback: (result) {
          showSnackBar(
            context: context,
            text: result is String ? result : 'Referral code claimed',
            backgroundColor: result is String
                ? ColorPalette.dReaderRed
                : ColorPalette.dReaderGreen,
          );
        },
      );
}
