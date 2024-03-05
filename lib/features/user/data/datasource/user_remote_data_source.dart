import 'package:d_reader_flutter/features/user/domain/models/user.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/wallet.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/wallet_asset.dart';
import 'package:d_reader_flutter/shared/data/remote/network_service.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';

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
  Future<void> requestPasswordReset(String email);
  Future<void> requestEmailVerification();
  Future<void> requestChangeEmail(String newEmail);
  Future<Either<AppException, List<WalletModel>>> getUserWallets(int id);
  Future<Either<AppException, List<WalletAsset>>> getUserAssets(int id);
  Future<void> insertFcmToken(String fcmToken);
}

class UserRemoteDataSource implements UserDataSource {
  final NetworkService networkService;

  UserRemoteDataSource(this.networkService);

  @override
  Future<void> insertFcmToken(String fcmToken) {
    // TODO: implement insertFcmToken
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, UserModel>> getMe() {
    // TODO: implement myUser
    throw UnimplementedError();
  }

  @override
  Future<void> requestChangeEmail(String newEmail) {
    // TODO: implement requestChangeEmail
    throw UnimplementedError();
  }

  @override
  Future<void> requestEmailVerification() {
    // TODO: implement requestEmailVerification
    throw UnimplementedError();
  }

  @override
  Future<void> requestPasswordReset(String email) {
    // TODO: implement requestPasswordReset
    throw UnimplementedError();
  }

  @override
  Future<void> syncWallets(int id) {
    // TODO: implement syncWallets
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, UserModel>> updateAvatar(
      UpdateUserPayload payload) {
    // TODO: implement updateAvatar
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, bool>> updatePassword(
      {required int userId,
      required String oldPassword,
      required String newPassword}) {
    // TODO: implement updatePassword
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, UserModel>> updateUser(
      UpdateUserPayload payload) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<WalletAsset>>> getUserAssets(int id) {
    // TODO: implement userAssets
    throw UnimplementedError();
  }

  @override
  Future<Either<AppException, List<WalletModel>>> getUserWallets(int id) {
    // TODO: implement userWallets
    throw UnimplementedError();
  }
}


//   @override
//   Future<UserModel?> myUser() async {
//     try {
//       final response =
//           await client.get('/user/get/me').then((value) => value.data);
//       return response != null ? UserModel.fromJson(response) : null;
//     } catch (error) {
//       throw Exception(error.toString());
//     }
//   }

//   @override
//   Future<dynamic> updateAvatar(UpdateUserPayload payload) async {
//     if (payload.avatar == null) {
//       return null;
//     }
//     String fileName = payload.avatar!.path.split('/').last;

//     FormData formData = FormData.fromMap({
//       "avatar": MultipartFile.fromBytes(
//         payload.avatar!.readAsBytesSync(),
//         filename: fileName,
//       ),
//     });
//     final response = await client
//         .patch('/user/update/${payload.id}/avatar', data: formData)
//         .then((value) => value.data)
//         .onError((error, stackTrace) {
//       if (error is DioException) {
//         return error.response?.data['message'];
//       }
//     });
//     return response != null
//         ? response is String
//             ? response
//             : UserModel.fromJson(response)
//         : null;
//   }

//   @override
//   Future<dynamic> updateUser(
//     UpdateUserPayload payload,
//   ) async {
//     final response = await client.patch(
//       '/user/update/${payload.id}',
//       data: {
//         if (payload.name != null && payload.name!.isNotEmpty)
//           "name": payload.name,
//         if (payload.email != null && payload.email!.isNotEmpty)
//           "email": payload.email,
//         if (payload.referrer != null && payload.referrer!.isNotEmpty)
//           "referrer": payload.referrer
//       },
//     ).then((value) {
//       return value.data;
//     }).onError((error, stackTrace) {
//       Sentry.captureException(error,
//           stackTrace: 'failed update user.${stackTrace.toString()}');
//       if (error is DioException) {
//         return error;
//       }
//     });

//     return response != null
//         ? response is DioException
//             ? response.response?.data['message'].toString()
//             : UserModel.fromJson(response)
//         : null;
//   }

//   @override
//   Future syncWallets(int id) {
//     return client.get('/user/sync-wallets/$id').then((value) => value.data);
//   }

//   @override
//   Future<void> requestEmailVerification() {
//     return client.patch('/user/request-email-verification');
//   }

//   @override
//   Future<List<WalletModel>> userWallets(int id) async {
//     try {
//       final response =
//           await client.get('/user/get/$id/wallets').then((value) => value.data);

//       return response != null
//           ? List<WalletModel>.from(
//               response.map(
//                 (item) => WalletModel.fromJson(item),
//               ),
//             )
//           : [];
//     } catch (exception, stackTrace) {
//       Sentry.captureException(exception,
//           stackTrace: 'Get user wallets ${stackTrace.toString()}');
//       throw Exception(exception);
//     }
//   }

//   @override
//   Future<List<WalletAsset>> userAssets(int id) async {
//     try {
//       final response =
//           await client.get('/user/get/$id/assets').then((value) => value.data);

//       return response != null
//           ? List<WalletAsset>.from(
//               response.map(
//                 (item) => WalletAsset.fromJson(item),
//               ),
//             )
//           : [];
//     } catch (exception, stackTrace) {
//       Sentry.captureException(exception,
//           stackTrace: 'User assets: ${stackTrace.toString()}');
//       throw Exception(exception);
//     }
//   }

//   @override
//   Future<dynamic> updatePassword({
//     required int userId,
//     required String oldPassword,
//     required String newPassword,
//   }) async {
//     final result = await client
//         .patch('/user/update-password/$userId', data: {
//           'oldPassword': oldPassword,
//           'newPassword': newPassword,
//         })
//         .then((value) => value.data)
//         .onError((exception, stackTrace) {
//           if (exception is DioException) {
//             final dynamic message = exception.response?.data?['message'];
//             return message != null
//                 ? message is List
//                     ? message.join('. ')
//                     : message
//                 : exception.response?.data.toString();
//           }
//         });
//     return result;
//   }

//   @override
//   Future<dynamic> requestPasswordReset(String email) async {
//     try {
//       await client
//           .patch('/user/request-password-reset', data: {'nameOrEmail': email});
//     } catch (exception) {
//       if (exception is DioException) {
//         final message = exception.response?.data['message'] ??
//             exception.response?.data.toString();
//         throw BadRequestException(
//             message is String ? message : message.toString());
//       }
//       throw Exception(exception);
//     }
//   }

//   @override
//   Future<void> requestChangeEmail(String newEmail) async {
//     try {
//       await client
//           .patch('/user/request-email-change', data: {"newEmail": newEmail});
//     } catch (exception) {
//       if (exception is DioException) {
//         final message = exception.response?.data['message'] ??
//             exception.response?.data.toString();
//         throw BadRequestException(
//             message is String ? message : message.toString());
//       }
//       throw Exception(exception);
//     }
//   }

//   @override
//   Future<void> insertFcmToken(String fcmToken) async {
//     await client.post('/user/device/$fcmToken');
//   }
// }

