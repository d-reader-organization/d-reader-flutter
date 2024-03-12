import 'dart:io' show File;

import 'package:d_reader_flutter/features/user/domain/providers/user_provider.dart';
import 'package:d_reader_flutter/features/user/presentations/providers/user_providers.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/features/user/domain/models/user.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  void build() {}

  Future<void> changeEmail({
    required String newEmail,
    required void Function() onSuccess,
    required void Function(String cause) onBadRequestException,
  }) async {
    ref.read(globalNotifierProvider.notifier).updateLoading(true);

    try {
      await ref.read(userRepositoryProvider).requestChangeEmail(newEmail);
      ref.read(globalNotifierProvider.notifier).updateLoading(false);
      onSuccess();
    } catch (exception) {
      ref.read(globalNotifierProvider.notifier).updateLoading(false);
      if (exception is BadRequestException) {
        onBadRequestException(exception.cause);
      }
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required int userId,
    required void Function(dynamic result) callback,
  }) async {
    ref.read(globalNotifierProvider.notifier).updateLoading(true);
    final result = await ref.read(userRepositoryProvider).updatePassword(
          userId: userId,
          oldPassword: oldPassword,
          newPassword: newPassword,
        );
    ref.read(globalNotifierProvider.notifier).updateLoading(false);
    callback(result);
  }

  Future<void> changeUsername({
    required UserModel user,
    required void Function(dynamic result) callback,
  }) async {
    final String username = ref.read(usernameTextProvider);
    if (username.isNotEmpty) {
      ref.read(globalNotifierProvider.notifier).updateLoading(true);
      final updateResult = await ref.read(userRepositoryProvider).updateUser(
            UpdateUserPayload(
              id: user.id,
              email: user.email,
              name: username,
            ),
          );
      ref.read(globalNotifierProvider.notifier).updateLoading(false);
      ref.read(usernameTextProvider.notifier).update((state) => '');
      ref.invalidate(myUserProvider);
      callback(updateResult);
    }
  }

  Future<void> syncUserWallets({
    required int userId,
    required void Function() callback,
  }) async {
    ref.read(globalNotifierProvider.notifier).updateLoading(true);
    await ref.read(userRepositoryProvider).syncWallets(userId);
    ref.read(globalNotifierProvider.notifier).updateLoading(false);
    callback();
  }

  Future<void> uploadAvatar({
    required int userId,
    required void Function(dynamic result) callback,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path ?? '');

      final notifier = ref.read(privateLoadingProvider.notifier);
      notifier.update(
        (state) => true,
      );
      final response = await ref.read(userRepositoryProvider).updateAvatar(
            UpdateUserPayload(
              id: userId,
              avatar: file,
            ),
          );
      ref.invalidate(myUserProvider);
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          notifier.update((state) => false);
        },
      );
      callback(response);
    }
  }

  void sendResetPasswordInstructions({
    required String email,
    required void Function(String result) callback,
  }) {
    ref.read(globalNotifierProvider.notifier).updateLoading(true);
    ref.read(userRepositoryProvider).requestPasswordReset(email);
    ref.read(globalNotifierProvider.notifier).updateLoading(false);
    callback('Instructions have been sent.');
  }
}
