import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final dioProvider = Provider.family<Dio, String?>((ref, overrideApiUrl) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: overrideApiUrl ?? ref.watch(environmentProvider).apiUrl,
    ),
  );
  return dio
    ..interceptors.addAll(
      [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Add the access token to the request header
            options.headers['Authorization'] =
                ref.watch(environmentProvider).jwtToken;
            return handler.next(options);
          },
          onError: (DioError e, handler) async {
            if (e.response?.statusCode == 401) {
              // If a 401 response is received, refresh the access token
              String? newAccessToken = await dio
                  .get<String?>(
                      '/auth/wallet/refresh-token/${ref.read(environmentProvider).refreshToken}')
                  .then(
                    (value) => value.data,
                  );

              // Update the request header with the new access token
              e.requestOptions.headers['Authorization'] = newAccessToken;

              // Repeat the request with the updated header
              return handler.resolve(await dio.fetch(e.requestOptions));
            }
            return handler.next(e);
          },
        ),
      ],
    );
});
