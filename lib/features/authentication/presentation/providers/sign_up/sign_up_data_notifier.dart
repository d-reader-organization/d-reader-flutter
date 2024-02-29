import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/state/sign_up_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_data_notifier.g.dart';

@Riverpod(keepAlive: true)
class SignUpDataNotifier extends _$SignUpDataNotifier {
  @override
  SignUpData build() {
    return const SignUpData();
  }

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  void updateEmailAndPassword({
    required String email,
    required String password,
  }) {
    state = state.copyWith(email: email, password: password);
  }

  void updateSucces(bool isSuccess) {
    state = state.copyWith(
      isSuccess: isSuccess,
      email: '',
      password: '',
      username: '',
    );
  }

  void clearData() {
    state = state.copyWith(email: '', password: '', username: '');
  }
}
