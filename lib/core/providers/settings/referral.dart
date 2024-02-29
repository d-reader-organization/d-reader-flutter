import 'package:d_reader_flutter/core/providers/common_text_controller_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/shared/domain/models/user.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'referral.g.dart';

@riverpod
class ReferralController extends _$ReferralController {
  late StateController<GlobalState> globalNotifier;
  @override
  FutureOr<void> build() {
    globalNotifier = ref.read(globalStateProvider.notifier);
  }

  handleSave({
    required String referrer,
    required void Function(dynamic result) callback,
  }) async {
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    final currentUser = ref.read(environmentNotifierProvider).user;
    dynamic updateResult;
    if (currentUser != null) {
      updateResult = await ref.read(userRepositoryProvider).updateUser(
            UpdateUserPayload(
              id: currentUser.id,
              referrer: referrer,
            ),
          );
    }

    ref.invalidate(myUserProvider);
    final result = await ref.read(myUserProvider.future);
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: false,
      ),
    );
    ref.read(environmentNotifierProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            user: result,
          ),
        );

    ref.read(commonTextEditingController).clear();
    ref.read(commonTextValue.notifier).state = '';
    callback(updateResult);
  }
}
