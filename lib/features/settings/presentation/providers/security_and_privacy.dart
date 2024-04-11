import 'package:d_reader_flutter/features/user/domain/models/user_privacy_consent.dart';
import 'package:d_reader_flutter/features/user/domain/providers/user_provider.dart';
import 'package:d_reader_flutter/features/user/presentation/providers/user_providers.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'security_and_privacy.g.dart';

@riverpod
class SecurityAndPrivacyController extends _$SecurityAndPrivacyController {
  @override
  void build() {}

  Future<void> updateUserConsents({
    required Map<ConsentType, bool> data,
    required Future<bool> Function() triggerDialog,
    required void Function() onSuccess,
    required void Function(String message) onFail,
  }) async {
    final localConsentData = ref.read(localUserConsentsProvider);
    final shouldUpdateMarketingConsent =
        data[ConsentType.marketing] != localConsentData[ConsentType.marketing];
    final shouldUpdateDataAnalytics = data[ConsentType.dataAnalytics] !=
        localConsentData[ConsentType.dataAnalytics];
    String errorMessage = '';
    if (shouldUpdateMarketingConsent || shouldUpdateDataAnalytics) {
      final shouldContinue = await triggerDialog();
      if (!shouldContinue) {
        return;
      }
    }
    ref.read(globalNotifierProvider.notifier).updateLoading(true);
    if (shouldUpdateMarketingConsent) {
      final response = await ref
          .read(userRepositoryProvider)
          .createUserPrivacyConsent(
            isConsentGiven: localConsentData[ConsentType.marketing] ?? false,
            consentType: ConsentType.marketing,
          );

      response.fold(
          (exception) => errorMessage = exception.message, (p0) => null);
    }

    if (shouldUpdateDataAnalytics) {
      final response =
          await ref.read(userRepositoryProvider).createUserPrivacyConsent(
                isConsentGiven:
                    localConsentData[ConsentType.dataAnalytics] ?? false,
                consentType: ConsentType.dataAnalytics,
              );
      response.fold(
          (exception) => errorMessage = exception.message, (p0) => null);
    }
    ref.read(globalNotifierProvider.notifier).updateLoading(false);
    if (errorMessage.isNotEmpty) {
      return onFail(errorMessage);
    }

    onSuccess();
    ref.invalidate(userConsentsProvider);
  }
}

final localUserConsentsProvider = StateProvider<Map<ConsentType, bool>>(
  (ref) {
    return {
      ConsentType.marketing: false,
      ConsentType.dataAnalytics: false,
    };
  },
);
