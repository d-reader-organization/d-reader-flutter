import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/auth_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VerifyEmailScreen extends ConsumerWidget {
  final String verificationId;
  const VerifyEmailScreen({
    super.key,
    required this.verificationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(verifyEmailProvider(verificationId));
    return Scaffold(
      body: provider.when(
        data: (data) {
          if (data != successResult) {
            return VerifyErrorWidget(
              errorMessage: data,
              verificationId: verificationId,
            );
          }
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Your email has been successfully verified, you can now browse the app while enjoying full features!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextButton(
                  backgroundColor: ColorPalette.dReaderYellow100,
                  textColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  size: const Size(double.infinity, 50),
                  onPressed: () {
                    nextScreenCloseOthers(
                      context: context,
                      path: RoutePath.home,
                    );
                  },
                  child: Text(
                    'Explore app',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return VerifyErrorWidget(verificationId: verificationId);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class VerifyErrorWidget extends ConsumerWidget {
  final String errorMessage, verificationId;
  const VerifyErrorWidget({
    super.key,
    this.errorMessage = '',
    required this.verificationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            'Something went wrong while verifying your email: $errorMessage',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 16,
          ),
          CustomTextButton(
            backgroundColor: ColorPalette.dReaderYellow100,
            textColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 4),
            size: const Size(double.infinity, 50),
            onPressed: () {
              ref.invalidate(verifyEmailProvider);
              ref.read(verifyEmailProvider(verificationId));
            },
            child: Text(
              'Try again',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
