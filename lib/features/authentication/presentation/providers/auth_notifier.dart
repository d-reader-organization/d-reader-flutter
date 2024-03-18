import 'package:d_reader_flutter/features/user/domain/providers/user_provider.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_notifier.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  void build() {}

  Future<void> handleRequestResetPassword({
    required String email,
    required Function() onSuccess,
    required Function(String cause) onException,
  }) async {
    ref.read(globalNotifierProvider.notifier).updateLoading(true);
    try {
      final response =
          await ref.read(userRepositoryProvider).requestPasswordReset(email);

      ref.read(globalNotifierProvider.notifier).updateLoading(false);
      response.fold((exception) {
        onException(exception.message);
      }, (result) {
        onSuccess();
      });
    } catch (exception) {
      ref.read(globalNotifierProvider.notifier).updateLoading(false);
      if (exception is BadRequestException) {
        onException(exception.cause);
      }
    }
  }
}
