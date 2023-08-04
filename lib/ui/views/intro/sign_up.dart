import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/views/intro/sign_up/step_1.dart';
import 'package:d_reader_flutter/ui/views/intro/sign_up/step_2.dart';
import 'package:d_reader_flutter/ui/views/intro/sign_up/step_2_verification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final signUpPageProvider = StateProvider<int>((ref) {
  return 0;
});

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
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(
          50,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
          ),
          child: Heading(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PageView(
            controller: _pageController,
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
                  _pageController.animateToPage(
                    2,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
              ),
              const SignUpStep2Verification(),
            ],
          ),
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
            ColorPalette.boxBackground400,
            BlendMode.srcIn,
          ),
        ),
        HeadingItem(
          step: 2,
          title: 'Email & pass',
          color: ref.watch(signUpPageProvider) > 0
              ? Colors.white
              : ColorPalette.boxBackground400,
        ),
        SvgPicture.asset(
          'assets/icons/arrow_right.svg',
          height: 16,
          width: 16,
          colorFilter: const ColorFilter.mode(
            ColorPalette.boxBackground400,
            BlendMode.srcIn,
          ),
        ),
        HeadingItem(
          step: 3,
          title: 'Wallet',
          color: ref.watch(signUpPageProvider) > 2
              ? Colors.white
              : ColorPalette.boxBackground400,
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
