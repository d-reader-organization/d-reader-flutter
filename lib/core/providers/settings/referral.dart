import 'package:d_reader_flutter/core/providers/common_text_controller_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/features/user/domain/providers/user_provider.dart';
import 'package:d_reader_flutter/features/user/domain/models/user.dart';
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
