import 'package:d_reader_flutter/features/user/domain/models/user.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/wallet.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/wallet_asset.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:dio/dio.dart';

abstract class UserDataSource {
  Future<Either<AppException, UserModel>> getMe();
  Future<Either<AppException, UserModel>> updateAvatar(
      UpdateUserPayload payload);
  Future<Either<AppException, UserModel>> updateUser(UpdateUserPayload payload);
  Future<Either<AppException, bool>> updatePassword({
    required int userId,
    required String oldPassword,
    required String newPassword,
  });
  Future<void> syncWallets(int id);
  Future<Either<AppException, bool>> requestPasswordReset(String email);
  Future<Either<AppException, bool>> requestEmailVerification();
  Future<Either<AppException, bool>> requestChangeEmail(String newEmail);
  Future<Either<AppException, List<WalletModel>>> getUserWallets(int id);
  Future<Either<AppException, List<WalletAsset>>> getUserAssets(int id);
  Future<void> insertFcmToken(String fcmToken);
}

class UserRemoteDataSource implements UserDataSource {
  final NetworkService networkService;

  UserRemoteDataSource(this.networkService);

  @override
  Future<void> insertFcmToken(String fcmToken) {
    return networkService.post('/user/device/$fcmToken');
  }

  @override
  Future<Either<AppException, UserModel>> getMe() async {
    try {
      final response = await networkService.get('/user/get/me');

      return response.fold((exception) => Left(exception), (result) {
        return Right(UserModel.fromJson(result.data));
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier:
              '${exception.toString()}UserRemoteDataSource.insertFcmToken',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, bool>> requestChangeEmail(String newEmail) async {
    try {
      final response = await networkService
          .patch('/user/request-email-change', data: {"newEmail": newEmail});
      return response.fold((exception) => Left(exception), (result) {
        return const Right(true);
      });
    } catch (exception) {
      throw Exception(exception);
    }
  }

  @override
  Future<Either<AppException, bool>> requestEmailVerification() async {
    final response =
        await networkService.patch('/user/request-email-verification');
    return response.fold(
      (exception) => Left(exception),
      (result) => const Right(
        true,
      ),
    );
  }

  @override
  Future<Either<AppException, bool>> requestPasswordReset(String email) async {
    try {
      final response = await networkService
          .patch('/user/request-password-reset', data: {'nameOrEmail': email});

      return response.fold((exception) => Left(exception), (data) {
        return const Right(true);
      });
    } catch (exception) {
      throw Exception(exception);
    }
  }

  @override
  Future<void> syncWallets(int id) {
    return networkService.get('/user/sync-wallets/$id');
  }

  @override
  Future<Either<AppException, UserModel>> updateAvatar(
      UpdateUserPayload payload) async {
    try {
      String fileName = payload.avatar!.path.split('/').last;

      FormData formData = FormData.fromMap({
        "avatar": MultipartFile.fromBytes(
          payload.avatar!.readAsBytesSync(),
          filename: fileName,
        ),
      });
      final response = await networkService
          .patch('/user/update/${payload.id}/avatar', formData: formData);
      return response.fold((exception) => Left(exception), (result) {
        return Right(UserModel.fromJson(result.data));
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier:
              '${exception.toString()}UserRemoteDataSource.insertFcmToken',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, bool>> updatePassword(
      {required int userId,
      required String oldPassword,
      required String newPassword}) async {
    try {
      final response =
          await networkService.patch('/user/update-password/$userId', data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });
      return response.fold((exception) => Left(exception), (result) {
        return const Right(true);
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier:
              '${exception.toString()}UserRemoteDataSource.insertFcmToken',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, UserModel>> updateUser(
      UpdateUserPayload payload) async {
    try {
      final response = await networkService.patch(
        '/user/update/${payload.id}',
        data: {
          if (payload.name != null && payload.name!.isNotEmpty)
            "name": payload.name,
          if (payload.email != null && payload.email!.isNotEmpty)
            "email": payload.email,
          if (payload.referrer != null && payload.referrer!.isNotEmpty)
            "referrer": payload.referrer
        },
      );

      return response.fold((exception) => Left(exception), (result) {
        return Right(UserModel.fromJson(result.data));
      });
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier:
              '${exception.toString()}UserRemoteDataSource.insertFcmToken',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, List<WalletAsset>>> getUserAssets(int id) async {
    try {
      final response = await networkService.get('/user/get/$id/assets');

      return response.fold(
        (exception) => Left(exception),
        (result) {
          return Right(
            List<WalletAsset>.from(
              result.data.map(
                (item) => WalletAsset.fromJson(item),
              ),
            ),
          );
        },
      );
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier:
              '${exception.toString()}UserRemoteDataSource.insertFcmToken',
        ),
      );
    }
  }

  @override
  Future<Either<AppException, List<WalletModel>>> getUserWallets(int id) async {
    try {
      final response = await networkService.get('/user/get/$id/wallets');

      return response.fold(
        (exception) => Left(exception),
        (result) {
          return Right(
            List<WalletModel>.from(
              result.data.map(
                (item) => WalletModel.fromJson(item),
              ),
            ),
          );
        },
      );
    } catch (exception) {
      return Left(
        AppException(
          message: 'Unknown exception occurred',
          statusCode: 500,
          identifier:
              '${exception.toString()}UserRemoteDataSource.insertFcmToken',
        ),
      );
    }
  }
}
