import 'package:d_reader_flutter/core/models/exceptions.dart';
import 'package:d_reader_flutter/core/models/user.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/models/wallet_asset.dart';
import 'package:d_reader_flutter/core/repositories/user/repository.dart';
import 'package:dio/dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class UserRepositoryImpl implements UserRepository {
  final Dio client;

  UserRepositoryImpl({
    required this.client,
  });

  @override
  Future<UserModel?> myUser() async {
    try {
      final response =
          await client.get('/user/get/me').then((value) => value.data);
      return response != null ? UserModel.fromJson(response) : null;
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  @override
  Future<dynamic> updateAvatar(UpdateUserPayload payload) async {
    if (payload.avatar == null) {
      return null;
    }
    String fileName = payload.avatar!.path.split('/').last;

    FormData formData = FormData.fromMap({
      "avatar": MultipartFile.fromBytes(
        payload.avatar!.readAsBytesSync(),
        filename: fileName,
      ),
    });
    final response = await client
        .patch('/user/update/${payload.id}/avatar', data: formData)
        .then((value) => value.data)
        .onError((error, stackTrace) {
      if (error is DioException) {
        return error.response?.data['message'];
      }
    });
    return response != null
        ? response is String
            ? response
            : UserModel.fromJson(response)
        : null;
  }

  @override
  Future<dynamic> updateUser(
    UpdateUserPayload payload,
  ) async {
    final response = await client.patch(
      '/user/update/${payload.id}',
      data: {
        if (payload.name != null && payload.name!.isNotEmpty)
          "name": payload.name,
        if (payload.email != null && payload.email!.isNotEmpty)
          "email": payload.email,
        if (payload.referrer != null && payload.referrer!.isNotEmpty)
          "referrer": payload.referrer
      },
    ).then((value) {
      return value.data;
    }).onError((error, stackTrace) {
      Sentry.captureException(error,
          stackTrace: 'failed update user.${stackTrace.toString()}');
      if (error is DioException) {
        return error;
      }
    });

    return response != null
        ? response is DioException
            ? response.response?.data['message'].toString()
            : UserModel.fromJson(response)
        : null;
  }

  @override
  Future<bool> validateName(String name) async {
    if (name.trim().isEmpty) {
      return false;
    }
    try {
      final response = await client
          .get('/auth/user/validate-name/$name')
          .then((value) => value.data);
      return response != null ? true : false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> validateEmail(String email) async {
    if (email.trim().isEmpty) {
      return false;
    }
    try {
      final response = await client
          .get('/auth/user/validate-email/$email')
          .then((value) => value.data);
      return response != null ? true : false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> updateReferrer(String referrer) async {
    final response = await client
        .patch(
      '/user/redeem-referral/$referrer',
    )
        .then((value) {
      return 'OK';
    }).onError((error, stackTrace) {
      if (error is DioException) {
        return error.response?.data['message'];
      }
      return error.toString();
    });

    return response;
  }

  @override
  Future syncWallets(int id) {
    return client.get('/user/sync-wallets/$id').then((value) => value.data);
  }

  @override
  Future<void> resetPassword(String id) {
    return client.patch('/user/reset-password', queryParameters: {
      'id': id,
    });
  }

  @override
  Future<void> requestEmailVerification() {
    return client.patch('/user/request-email-verification');
  }

  @override
  Future<List<WalletModel>> userWallets(int id) async {
    try {
      final response =
          await client.get('/user/get/$id/wallets').then((value) => value.data);

      return response != null
          ? List<WalletModel>.from(
              response.map(
                (item) => WalletModel.fromJson(item),
              ),
            )
          : [];
    } catch (exception, stackTrace) {
      Sentry.captureException(exception,
          stackTrace: 'Get user wallets ${stackTrace.toString()}');
      throw Exception(exception);
    }
  }

  @override
  Future<List<WalletAsset>> userAssets(int id) async {
    try {
      final response =
          await client.get('/user/get/$id/assets').then((value) => value.data);

      return response != null
          ? List<WalletAsset>.from(
              response.map(
                (item) => WalletAsset.fromJson(item),
              ),
            )
          : [];
    } catch (exception, stackTrace) {
      Sentry.captureException(exception,
          stackTrace: 'User assets: ${stackTrace.toString()}');
      throw Exception(exception);
    }
  }

  @override
  Future<dynamic> updatePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  }) async {
    final result = await client
        .patch('/user/update-password/$userId', data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        })
        .then((value) => value.data)
        .onError((exception, stackTrace) {
          if (exception is DioException) {
            final dynamic message = exception.response?.data?['message'];
            return message != null
                ? message is List
                    ? message.join('. ')
                    : message
                : exception.response?.data.toString();
          }
        });
    return result;
  }

  @override
  Future<dynamic> requestPasswordReset(String email) async {
    try {
      await client
          .patch('/user/request-password-reset', data: {'email': email});
    } catch (exception) {
      if (exception is DioException) {
        final message = exception.response?.data['message'] ??
            exception.response?.data.toString();
        throw BadRequestException(message);
      }
      throw Exception(exception);
    }
  }
}
