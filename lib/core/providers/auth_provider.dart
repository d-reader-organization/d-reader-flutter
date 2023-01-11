import 'package:d_reader_flutter/config/config.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable // preferred to use immutable states
class AuthState {
  const AuthState({
    this.token,
  });
  final String? token;
  bool get isAuthorized => token != null;
  AuthState copyWith({required String? token}) {
    return AuthState(token: token);
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier([String? token]) : super(AuthState(token: token));

  void _setToken(String token) {
    state = state.copyWith(token: token);
  }

  Future<void> storeToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(Config.tokenKey, token);
    _setToken(token);
  }

  Future<void> clearToken() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(Config.tokenKey);
    state = state.copyWith(token: null);
  }
}
