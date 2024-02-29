import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:d_reader_flutter/routing/router.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/ui/views/intro/initial.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'dio_provider.g.dart';

@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ref.watch(environmentNotifierProvider).apiUrl,
    ),
  );
  return dio
    ..interceptors.addAll(
      [
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Add the access token to the request header
            options.headers['Authorization'] =
                ref.watch(environmentNotifierProvider).jwtToken;
            return handler.next(options);
          },
          onError: (DioException e, handler) async {
            // if (e.response?.statusCode == 401) {
            //   // If a 401 response is received, refresh the access token
            //   String? newAccessToken = await dio
            //       .get<String?>(
            //           '/auth/wallet/refresh-token/${ref.read(environmentNotifierProvider).refreshToken}')
            //       .then(
            //         (value) => value.data,
            //       );

            //   // Update the request header with the new access token
            //   e.requestOptions.headers['Authorization'] = newAccessToken;
            //   Sentry.captureException(e.response);
            //   // Repeat the request with the updated header
            //   return handler.resolve(await dio.fetch(e.requestOptions));
            // }

            // temp production fix
            if (e.response?.statusCode == 401 ||
                (e.response?.statusCode == 404 &&
                    e.response?.requestOptions.path == '/user/get/me')) {
              await LocalStore.instance.clear();
              ref.invalidate(environmentNotifierProvider);
              routerNavigatorKey.currentState!.push(
                MaterialPageRoute(
                  builder: (context) => const InitialIntroScreen(),
                ),
              );
              return;
            }
            return handler.next(e);
          },
        ),
      ],
    );
}
