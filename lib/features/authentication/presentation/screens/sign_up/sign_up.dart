import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/sign_up_data_notifier.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/sign_up_notifier.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/sign_up_providers.dart';
import 'package:d_reader_flutter/features/authentication/presentation/screens/sign_up/username_step.dart';
import 'package:d_reader_flutter/features/authentication/presentation/screens/sign_up/email_and_password_step.dart';
import 'package:d_reader_flutter/features/authentication/presentation/screens/sign_up/verification_step.dart';
import 'package:d_reader_flutter/features/authentication/presentation/screens/sign_up/connect_wallet_step.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final PageController _pageController = PageController();
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          56,
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: const _Heading(),
        ),
      ),
      body: ref.watch(signUpDataNotifierProvider).googleAccessToken.isNotEmpty
          ? _GoogleSignUpForm(pageController: _pageController)
          : _RegularSignUpForm(pageController: _pageController),
    );
  }
}

class _RegularSignUpForm extends ConsumerWidget {
  final PageController pageController;
  const _RegularSignUpForm({
    required this.pageController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageView(
      controller: pageController,
      physics: ref.watch(signUpPageProvider) > 2
          ? const NeverScrollableScrollPhysics()
          : null,
      onPageChanged: (value) {
        ref.read(signUpPageProvider.notifier).update((state) => value);
      },
      children: [
        SignUpUsernameStep(
          onSuccess: () {
            pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          },
        ),
        SignUpEmailAndPasswordStep(
          onSuccess: () {
            ref.read(signUpDataNotifierProvider.notifier).updateSuccess(true);
            pageController.animateToPage(
              2,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          },
          onFail: (text) {
            showSnackBar(
              context: context,
              text: text,
              backgroundColor: ColorPalette.dReaderRed,
            );
          },
        ),
        if (ref.watch(signUpDataNotifierProvider).isSuccess) ...[
          SignUpVerificationStep(
            handleNext: () {
              pageController.animateToPage(
                3,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
          ),
          const SignUpConnectWalletStep(),
        ],
      ],
    );
  }
}

class _GoogleSignUpForm extends ConsumerWidget {
  final PageController pageController;
  const _GoogleSignUpForm({
    required this.pageController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (value) {
        ref.read(signUpPageProvider.notifier).update((state) => value);
      },
      children: [
        SignUpUsernameStep(
          overrideNext: () {
            ref.read(signUpNotifierProvider.notifier).googleSignUp(
              onSuccess: () {
                ref
                    .read(signUpDataNotifierProvider.notifier)
                    .updateSuccess(true);
                pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
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
          onSuccess: () {},
        ),
        if (ref.watch(signUpDataNotifierProvider).isSuccess) ...[
          const SignUpConnectWalletStep(),
        ],
      ],
    );
  }
}

class _Heading extends ConsumerWidget {
  const _Heading();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _HeadingItem(
          step: 1,
          title: 'Username',
          color: Colors.white,
        ),
        SvgPicture.asset(
          'assets/icons/arrow_right.svg',
          height: 16,
          width: 16,
          colorFilter: const ColorFilter.mode(
            ColorPalette.greyscale200,
            BlendMode.srcIn,
          ),
        ),
        if (ref
            .watch(signUpDataNotifierProvider)
            .googleAccessToken
            .isEmpty) ...[
          _HeadingItem(
            step: 2,
            title: 'Email & pass',
            color: ref.watch(signUpPageProvider) > 0
                ? Colors.white
                : ColorPalette.greyscale200,
          ),
          SvgPicture.asset(
            'assets/icons/arrow_right.svg',
            height: 16,
            width: 16,
            colorFilter: const ColorFilter.mode(
              ColorPalette.greyscale200,
              BlendMode.srcIn,
            ),
          ),
        ],
        _HeadingItem(
          step:
              ref.watch(signUpDataNotifierProvider).googleAccessToken.isNotEmpty
                  ? 2
                  : 3,
          title: 'Wallet',
          color: ref.watch(signUpPageProvider) > 2
              ? Colors.white
              : ColorPalette.greyscale200,
        ),
      ],
    );
  }
}

class _HeadingItem extends StatelessWidget {
  final int step;
  final String title;
  final Color color;
  const _HeadingItem({
    required this.step,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$step',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
