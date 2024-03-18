import 'package:d_reader_flutter/features/user/domain/providers/user_provider.dart';
import 'package:d_reader_flutter/features/user/domain/models/user.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:d_reader_flutter/shared/presentations/providers/common/common_text_controller_provider.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'referral.g.dart';

@riverpod
class ReferralController extends _$ReferralController {
  @override
  void build() {}

  handleSave({
    required String referrer,
    required void Function(dynamic result) callback,
  }) async {
    ref.read(globalNotifierProvider.notifier).updateLoading(true);

    final currentUser = ref.read(environmentProvider).user;
    if (currentUser == null) {
      return;
    }

    final response = await ref.read(userRepositoryProvider).updateUser(
          UpdateUserPayload(
            id: currentUser.id,
            referrer: referrer,
          ),
        );
    ref.read(globalNotifierProvider.notifier).updateLoading(false);
    response.fold((exception) {
      callback(exception.message);
    }, (user) {
      ref.read(environmentProvider.notifier).updateEnvironmentState(
            EnvironmentStateUpdateInput(
              user: user,
            ),
          );

      ref.read(commonTextEditingController).clear();
      ref.read(commonTextValue.notifier).state = '';
      callback(true);
    });
  }
}
