import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SecurePasswordIcon extends ConsumerWidget {
  final bool isAdditional;
  const SecurePasswordIcon({
    super.key,
    this.isAdditional = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          ref
              .read(isAdditional
                  ? additionalObscureTextProvider.notifier
                  : obscureTextProvider.notifier)
              .update((state) => !state);
        },
        child: Icon(
          ref.watch(isAdditional
                  ? additionalObscureTextProvider
                  : obscureTextProvider)
              ? FontAwesomeIcons.solidEye
              : FontAwesomeIcons.solidEyeSlash,
          color: ColorPalette.greyscale300,
          size: 20,
        ),
      ),
    );
  }
}
