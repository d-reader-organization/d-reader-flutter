import 'package:d_reader_flutter/features/authentication/presentation/providers/auth_providers.dart';
import 'package:d_reader_flutter/routing/router.dart';
import 'package:d_reader_flutter/shared/data/remote/dio_network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/features/home/presentation/screens/initial.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final networkServiceProvider = Provider<DioNetworkService>(
  (ref) {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ref.watch(environmentProvider).apiUrl,
      ),
    )..interceptors.addAll(
        [
          InterceptorsWrapper(
            onRequest: (options, handler) {
              if (!options.path.contains('google')) {
                // Add the access token to the request header
                // TODO add this at service level
                options.headers['Authorization'] =
                    ref.watch(environmentProvider).jwtToken;
              }

              return handler.next(options);
            },
            onError: (DioException e, handler) async {
              // if (e.response?.statusCode == 401) {
              //   // If a 401 response is received, refresh the access token
              //   String? newAccessToken = await dio
              //       .get<String?>(
              //           '/auth/wallet/refresh-token/${ref.read(environmentProvider).refreshToken}')
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
                ref.read(logoutProvider);
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

    return DioNetworkService(dio: dio);
  },
);
