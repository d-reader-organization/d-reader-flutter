import 'dart:io' show File;

import 'package:d_reader_flutter/features/user/domain/providers/user_provider.dart';
import 'package:d_reader_flutter/features/user/presentations/providers/user_providers.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/features/user/domain/models/user.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  late StateController<GlobalState> globalNotifier;
  @override
  FutureOr<void> build() {
    globalNotifier = ref.read(globalStateProvider.notifier);
  }

  Future<void> changeEmail({
    required String newEmail,
    required void Function() onSuccess,
    required void Function(String cause) onBadRequestException,
  }) async {
    final globalNotifier = ref.read(globalStateProvider.notifier);
    globalNotifier.update(
      (state) => state.copyWith(isLoading: true),
    );
    try {
      await ref.read(userRepositoryProvider).requestChangeEmail(newEmail);
      globalNotifier.update(
        (state) => state.copyWith(
          isLoading: false,
        ),
      );
      onSuccess();
    } catch (exception) {
      globalNotifier.update(
        (state) => state.copyWith(
          isLoading: false,
        ),
      );
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
    final globalNotifier = ref.read(globalStateProvider.notifier);

    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    final result = await ref.read(userRepositoryProvider).updatePassword(
          userId: userId,
          oldPassword: oldPassword,
          newPassword: newPassword,
        );
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: false,
      ),
    );
    callback(result);
  }

  Future<void> changeUsername({
    required UserModel user,
    required void Function(dynamic result) callback,
  }) async {
    final String username = ref.read(usernameTextProvider);
    if (username.isNotEmpty) {
      globalNotifier.update(
        (state) => state.copyWith(
          isLoading: true,
        ),
      );
      final updateResult = await ref.read(userRepositoryProvider).updateUser(
            UpdateUserPayload(
              id: user.id,
              email: user.email,
              name: username,
            ),
          );
      globalNotifier.update(
        (state) => state.copyWith(
          isLoading: false,
        ),
      );
      ref.read(usernameTextProvider.notifier).update((state) => '');
      ref.invalidate(myUserProvider);
      callback(updateResult);
    }
  }

  Future<void> syncUserWallets({
    required int userId,
    required void Function() callback,
  }) async {
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    await ref.read(userRepositoryProvider).syncWallets(userId);
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: false,
      ),
    );
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
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    ref.read(userRepositoryProvider).requestPasswordReset(email);
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: false,
      ),
    );
    callback('Instructions have been sent.');
  }
}
