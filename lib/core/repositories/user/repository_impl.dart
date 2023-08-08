import 'package:d_reader_flutter/core/models/user.dart';
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
      if (error is DioError) {
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
    // TODO: test update user endpoint
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
      Sentry.captureException(error);
      if (error is DioError) {
        return error;
      }
    });

    return response != null
        ? response is DioError
            ? response.response?.data['message']
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
      if (error is DioError) {
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
}
