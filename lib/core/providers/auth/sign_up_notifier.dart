import 'package:hooks_riverpod/hooks_riverpod.dart';

final signUpDataProvider = NotifierProvider<SignUpDataProvider, SignUpData>(
  SignUpDataProvider.new,
);

class SignUpData {
  final String email, password, username;
  final bool isSuccess;
  SignUpData({
    this.email = '',
    this.password = '',
    this.username = '',
    this.isSuccess = false,
  });

  SignUpData copyWith({
    String? email,
    String? password,
    String? username,
    bool? isSuccess,
  }) {
    return SignUpData(
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class SignUpDataProvider extends Notifier<SignUpData> {
  @override
  SignUpData build() {
    return SignUpData();
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
