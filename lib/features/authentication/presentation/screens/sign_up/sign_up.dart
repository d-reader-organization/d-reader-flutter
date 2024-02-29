import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/sign_up_data_notifier.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/sign_up/sign_up_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/views/intro/sign_up/step_1.dart';
import 'package:d_reader_flutter/ui/views/intro/sign_up/step_2.dart';
import 'package:d_reader_flutter/ui/views/intro/sign_up/step_2_verification.dart';
import 'package:d_reader_flutter/ui/views/intro/sign_up/step_3.dart';
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            child: const Heading(),
          ),
        ),
        body: Consumer(
          builder: (context, ref, child) {
            return PageView(
              controller: _pageController,
              physics: ref.watch(signUpPageProvider) > 2
                  ? const NeverScrollableScrollPhysics()
                  : null,
              onPageChanged: (value) {
                ref.read(signUpPageProvider.notifier).update((state) => value);
              },
              children: [
                SignUpStep1(
                  onSuccess: () {
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  },
                ),
                SignUpStep2(
                  onSuccess: () {
                    ref
                        .read(signUpDataNotifierProvider.notifier)
                        .updateSucces(true);
                    _pageController.animateToPage(
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
                  SignUpStep2Verification(
                    handleNext: () {
                      _pageController.animateToPage(
                        3,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
                  const SignUpStep3(),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class Heading extends ConsumerWidget {
  const Heading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const HeadingItem(
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
        HeadingItem(
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
        HeadingItem(
          step: 3,
          title: 'Wallet',
          color: ref.watch(signUpPageProvider) > 2
              ? Colors.white
              : ColorPalette.greyscale200,
        ),
      ],
    );
  }
}

class HeadingItem extends StatelessWidget {
  final int step;
  final String title;
  final Color color;
  const HeadingItem({
    super.key,
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
