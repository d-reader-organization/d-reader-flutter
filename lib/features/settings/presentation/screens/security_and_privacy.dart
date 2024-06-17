import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/features/settings/presentation/providers/security_and_privacy.dart';
import 'package:d_reader_flutter/features/user/domain/models/user_privacy_consent.dart';
import 'package:d_reader_flutter/features/user/presentation/providers/user_providers.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/utils/url_utils.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/shared/widgets/switch/custom_switch.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/carrot_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class SecurityAndPrivacyScreen extends ConsumerWidget {
  const SecurityAndPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.appBackgroundColor,
        leadingWidth: 32,
        title: Text(
          'Security & Privacy',
          style: textTheme.headlineMedium,
        ),
      ),
      body: ref.watch(userConsentsProvider).when(
        data: (data) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'Safety & Privacy',
                  textAlign: TextAlign.start,
                  style: textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'Manage how we use data to personalise your dReader experience, and control how we can interact with you. To learn more, visit our Privacy Policy & Terms of Service.',
                  style: textTheme.bodyMedium
                      ?.copyWith(color: ColorPalette.greyscale100),
                ),
                const SizedBox(
                  height: 48,
                ),
                CustomSwitch(
                  title: 'Marketing and Advertisement',
                  isTurnedOn: ref.watch(
                          localUserConsentsProvider)[ConsentType.marketing] ??
                      false,
                  onChange: () {
                    ref
                        .read(localUserConsentsProvider.notifier)
                        .update((state) {
                      final Map<ConsentType, bool> mapCopy = Map.from(state);
                      mapCopy.update(ConsentType.marketing, (value) => !value);

                      return mapCopy;
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Allow dReader to send promotional emails for upcoming sales and events.',
                  style: textTheme.bodyMedium
                      ?.copyWith(color: ColorPalette.greyscale100),
                ),
                const SizedBox(
                  height: 48,
                ),
                CustomSwitch(
                  title: 'Data Analytics',
                  isTurnedOn: ref.watch(localUserConsentsProvider)[
                          ConsentType.dataAnalytics] ??
                      false,
                  onChange: () {
                    ref
                        .read(localUserConsentsProvider.notifier)
                        .update((state) {
                      final Map<ConsentType, bool> mapCopy = Map.from(state);
                      mapCopy.update(
                          ConsentType.dataAnalytics, (value) => !value);

                      return mapCopy;
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'We don’t actually analyse user data, this button is pretty much useless at the moment.',
                  style: textTheme.bodyMedium
                      ?.copyWith(color: ColorPalette.greyscale100),
                ),
                const SizedBox(
                  height: 48,
                ),
                GestureDetector(
                  onTap: () {
                    openUrl(
                      Config.privacyPolicyUrl,
                      LaunchMode.inAppWebView,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Revise Privacy Policy',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SvgPicture.asset(
                        'assets/icons/arrow_right.svg',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        error: (exception, stackTrace) {
          return const CarrotErrorWidget(
            adviceText: 'We are working on a fix. Thanks for your patience!',
            mainErrorText: 'We ran into some issues',
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: ref.watch(userConsentsProvider).whenOrNull(
        data: (data) {
          final localUserConsentsData = ref.watch(localUserConsentsProvider);
          final showUpdateButton = data[ConsentType.marketing] !=
                  localUserConsentsData[ConsentType.marketing] ||
              data[ConsentType.dataAnalytics] !=
                  localUserConsentsData[ConsentType.dataAnalytics];
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: showUpdateButton ? 1 : 0,
            curve: Curves.easeInOut,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextButton(
                      size: const Size(double.infinity, 40),
                      onPressed: () {
                        ref.invalidate(userConsentsProvider);
                      },
                      borderRadius: BorderRadius.circular(8),
                      backgroundColor: Colors.transparent,
                      textColor: ColorPalette.greyscale50,
                      borderColor: ColorPalette.greyscale50,
                      child: const Text('Cancel'),
                    ),
                  ),
                  Expanded(
                    child: CustomTextButton(
                      isLoading: ref.watch(globalNotifierProvider).isLoading,
                      size: const Size(double.infinity, 40),
                      onPressed: () {
                        ref
                            .read(securityAndPrivacyControllerProvider.notifier)
                            .updateUserConsents(
                              data: data,
                              triggerDialog: () async {
                                return await triggerConfirmationDialog(
                                  context: context,
                                  title:
                                      'Revoking this consent might lead to degradation of services or limited access to app features',
                                  subtitle: '',
                                );
                              },
                              onSuccess: () {
                                showSnackBar(
                                  context: context,
                                  text:
                                      'Your consents are updated successfully',
                                  backgroundColor: ColorPalette.dReaderGreen,
                                );
                              },
                              onFail: (message) {
                                showSnackBar(
                                  context: context,
                                  text: message,
                                  backgroundColor: ColorPalette.dReaderRed,
                                );
                              },
                            );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
