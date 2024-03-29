import 'package:d_reader_flutter/shared/presentations/providers/common/common_text_controller_provider.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/features/settings/presentation/widgets/referrals/utils.dart';
import 'package:d_reader_flutter/features/settings/presentation/widgets/bottom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReferralBottomNavigation extends ConsumerWidget {
  const ReferralBottomNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String referrer = ref.watch(commonTextValue);
    return referrer.isNotEmpty
        ? SettingsButtonsBottom(
            isLoading: ref.watch(globalNotifierProvider).isLoading,
            onCancel: () {
              ref.read(commonTextEditingController).clear();
              ref.read(commonTextValue.notifier).state = '';
            },
            onSave: () async {
              await handleSave(context, ref, referrer);
            },
          )
        : const SizedBox();
  }
}
