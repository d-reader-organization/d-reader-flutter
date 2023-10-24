import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/launch_external_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InstallWalletBottomSheet extends ConsumerWidget {
  const InstallWalletBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: ColorPalette.greyscale400,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            28,
          ),
        ),
      ),
      child: ListView(
        children: [
          const Text(
            'We can\'t find the wallet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            'Get started with one of these',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Column(
            children: [
              const Divider(
                color: ColorPalette.greyscale100,
              ),
              WalletAppRow(
                appName: 'Espresso Cash',
                iconPath: 'assets/icons/wallets/espresso_cash.png',
                onPressed: () {
                  openExternalApp('com.pleasecrypto.flutter');
                },
              ),
              const Divider(
                color: ColorPalette.greyscale100,
              ),
              WalletAppRow(
                appName: 'Ultimate',
                iconPath: 'assets/icons/wallets/ultimate.svg',
                onPressed: () {
                  openExternalApp('fi.unstoppable.ultimate.android');
                },
              ),
              const Divider(
                color: ColorPalette.greyscale100,
              ),
              WalletAppRow(
                appName: 'Solflare',
                iconPath: 'assets/icons/wallets/solflare.svg',
                onPressed: () {
                  openExternalApp('com.solflare.mobile');
                },
              ),
              const Divider(
                color: ColorPalette.greyscale100,
              ),
              WalletAppRow(
                appName: 'Phantom',
                iconPath: 'assets/icons/wallets/phantom.svg',
                onPressed: () {
                  openExternalApp('app.phantom');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WalletAppRow extends StatelessWidget {
  final String appName, iconPath;
  final Function() onPressed;
  const WalletAppRow({
    super.key,
    required this.appName,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              iconPath.contains('espresso')
                  ? Image.asset(
                      iconPath,
                      height: 24,
                      width: 24,
                    )
                  : SvgPicture.asset(
                      iconPath,
                      height: 24,
                      width: 24,
                    ),
              const SizedBox(
                width: 8,
              ),
              Text(
                appName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          InstallWalletButton(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 8,
            ),
            onPressed: onPressed,
            textColor: Colors.black,
            size: const Size(48, 24),
            child: const Text(
              'Install',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InstallWalletButton extends StatelessWidget {
  final bool isLoading;
  final Function()? onPressed;
  final Color backgroundColor, borderColor, textColor;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsets padding;
  final double fontSize;
  final Widget child;
  final Size? size;
  const InstallWalletButton({
    super.key,
    required this.child,
    this.isLoading = false,
    this.onPressed,
    this.backgroundColor = ColorPalette.dReaderYellow100,
    this.borderRadius,
    this.borderColor = Colors.transparent,
    this.textColor = ColorPalette.appBackgroundColor,
    this.padding = const EdgeInsets.all(8),
    this.fontSize = 14,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        minimumSize: size,
        backgroundColor: backgroundColor,
        disabledBackgroundColor: ColorPalette.dReaderGrey,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          side: BorderSide(
            color: borderColor,
          ),
        ),
        foregroundColor: textColor,
        textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: ColorPalette.greyscale500,
              fontWeight: FontWeight.w700,
              fontSize: fontSize,
            ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: ColorPalette.appBackgroundColor,
              ),
            )
          : child,
    );
  }
}
