import 'package:d_reader_flutter/shared/presentations/providers/global/state/global_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_notifier.g.dart';

@riverpod
class GlobalNotifier extends _$GlobalNotifier {
  @override
  GlobalState build() {
    return const GlobalState(isLoading: false);
  }

  void update({required bool isLoading, bool? isMinting}) {
    state = state.copyWith(
      isLoading: isLoading,
      isMinting: isMinting,
    );
  }

  void updateLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void updateMinting(bool isMinting) {
    state = state.copyWith(isMinting: isMinting);
  }
}
