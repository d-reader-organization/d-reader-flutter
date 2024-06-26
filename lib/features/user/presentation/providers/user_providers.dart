import 'package:d_reader_flutter/features/settings/presentation/providers/security_and_privacy.dart';
import 'package:d_reader_flutter/features/user/domain/models/user.dart';
import 'package:d_reader_flutter/features/user/domain/models/user_privacy_consent.dart';
import 'package:d_reader_flutter/features/user/domain/providers/user_provider.dart';
import 'package:d_reader_flutter/features/wallet/domain/models/wallet.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_providers.g.dart';

@riverpod
Future<UserModel> myUser(MyUserRef ref) async {
  final response = await ref.read(userRepositoryProvider).getMe();
  return response.fold((exception) {
    throw exception;
  }, (user) {
    ref.read(environmentProvider.notifier).updateEnvironmentState(
          EnvironmentStateUpdateInput(
            user: user,
          ),
        );
    return user;
  });
}

@riverpod
Future<List<WalletModel>> userWallets(
  UserWalletsRef ref, {
  required int? id,
}) async {
  if (id != null) {
    final response = await ref.read(userRepositoryProvider).getUserWallets(id);
    return response.fold((exception) {
      throw exception;
    }, (wallets) {
      return wallets;
    });
  }
  return [];
}

final usernameTextProvider = StateProvider<String>(
  (ref) {
    return '';
  },
);

final oldPasswordProvider = StateProvider.autoDispose<String>(
  (ref) {
    return '';
  },
);

final newPasswordProvider = StateProvider.autoDispose<String>(
  (ref) {
    return '';
  },
);

final userConsentsProvider =
    FutureProvider.autoDispose<Map<ConsentType, bool>>((ref) async {
  final response =
      await ref.read(userRepositoryProvider).getUserPrivacyConsents();

  return response.fold((exception) => throw exception, (data) {
    final Map<ConsentType, bool> map = {};
    for (final userConsent in data) {
      map.update(
        userConsent.consentType.consentTypeFromString(),
        (value) => userConsent.isConsentGiven,
        ifAbsent: () => userConsent.isConsentGiven,
      );
      ref.read(localUserConsentsProvider.notifier).update((state) {
        state.update(
          userConsent.consentType.consentTypeFromString(),
          (value) => userConsent.isConsentGiven,
          ifAbsent: () => userConsent.isConsentGiven,
        );
        return state;
      });
    }
    return map;
  });
});
