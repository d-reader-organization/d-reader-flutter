import 'package:d_reader_flutter/core/models/user.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/common_text_controller_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

handleSave(BuildContext context, WidgetRef ref, String referrer) async {
  final notifier = ref.read(globalStateProvider.notifier);
  notifier.update(
    (state) => state.copyWith(
      isLoading: true,
    ),
  );
  final currentUser = ref.read(environmentProvider).user;
  dynamic updateResult;
  if (currentUser != null) {
    updateResult = await ref.read(userRepositoryProvider).updateUser(
          UpdateUserPayload(
            id: currentUser.id,
            referrer: referrer,
          ),
        );
  }

  notifier.update(
    (state) => state.copyWith(
      isLoading: false,
    ),
  );
  ref.invalidate(myUserProvider);
  final result = await ref.read(myUserProvider.future);
  ref.read(environmentProvider.notifier).updateEnvironmentState(
        EnvironmentStateUpdateInput(
          user: result,
        ),
      );

  if (context.mounted) {
    ref.read(commonTextEditingController).clear();
    ref.read(commonTextValue.notifier).state = '';

    showSnackBar(
      context: context,
      text: updateResult is String ? updateResult : 'Referral code claimed',
      backgroundColor: updateResult is String
          ? ColorPalette.dReaderRed
          : ColorPalette.dReaderGreen,
    );
  }
}
