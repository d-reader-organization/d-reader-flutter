import 'package:d_reader_flutter/features/authentication/presentation/providers/auth_providers.dart';
import 'package:d_reader_flutter/routing/router.dart';
import 'package:d_reader_flutter/shared/data/remote/dio_network_service.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/features/home/presentation/screens/initial.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void logoutAndRedirectToInitial(ProviderRef ref) {
  ref.read(logoutProvider);
  routerNavigatorKey.currentState!.push(
    MaterialPageRoute(
      builder: (context) => const InitialIntroScreen(),
    ),
  );
}

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
              if ((e.response?.statusCode == 404 &&
                  e.response?.requestOptions.path == '/user/get/me')) {
                logoutAndRedirectToInitial(ref);
                return;
              }
              return handler.next(e);
            },
          ),
          QueuedInterceptorsWrapper(
            onError: (error, handler) async {
              if (error.response?.statusCode == 401) {
                final Dio refreshTokenDio = Dio(BaseOptions(
                  baseUrl: ref.watch(environmentProvider).apiUrl,
                ));
                String? newAccessToken = await refreshTokenDio
                    .patch<String?>(
                        '/auth/user/refresh-token/${ref.read(environmentProvider).refreshToken}')
                    .then(
                      (value) => value.data,
                    )
                    .onError(
                  (exception, stackTrace) {
                    logoutAndRedirectToInitial(ref);
                    return null;
                  },
                );
                if (newAccessToken == null) {
                  return handler.next(error);
                }
                // Update the request header with the new access token
                error.requestOptions.headers['Authorization'] = newAccessToken;
                ref.read(environmentProvider.notifier).updateEnvironmentState(
                      EnvironmentStateUpdateInput(
                        jwtToken: newAccessToken,
                      ),
                    );
                return handler
                    .resolve(await refreshTokenDio.fetch(error.requestOptions));
              }
            },
          ),
        ],
      );

    return DioNetworkService(dio: dio);
  },
);
