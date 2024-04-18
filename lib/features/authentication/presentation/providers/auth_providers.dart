import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/sign_up_data_notifier.dart';
import 'package:d_reader_flutter/features/user/domain/providers/user_provider.dart';
import 'package:d_reader_flutter/shared/data/local/local_store.dart';
import 'package:d_reader_flutter/routing/router.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/common/tab_bar_provider.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/scaffold_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final logoutProvider = FutureProvider.autoDispose((ref) async {
  final currentNetwork = ref.read(environmentProvider).solanaCluster;
  ref.invalidate(scaffoldNavigationIndexProvider);
  ref.invalidate(environmentProvider);
  ref.read(environmentProvider);
  ref.invalidate(tabBarProvider);
  ref.invalidate(signUpDataNotifierProvider);
  await GoogleSignIn().signOut();
  await Future.wait([
    LocalStore.instance.delete(
      'last-network',
    ),
    LocalStore.instance.delete(Config.hasSeenInitialKey),
    LocalStore.instance.clear(),
  ]);
  await ref
      .read(environmentProvider.notifier)
      .clearDataFromLocalStore(currentNetwork);
  ref.read(authRouteProvider).logout();
});

final verifyEmailProvider = FutureProvider.autoDispose
    .family<String, String>((ref, verificationId) async {
  final result =
      await ref.read(userRepositoryProvider).verifyEmail(verificationId);

  return result.fold((exception) => exception.message, (_) => successResult);
});
