import 'package:d_reader_flutter/constants/enums.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/digital_asset/domain/models/digital_asset.dart';
import 'package:d_reader_flutter/features/transaction/presentation/providers/unwrap/notifier/unwrap_notifier.dart';
import 'package:d_reader_flutter/shared/data/local/local_store.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/shared/widgets/checkbox/custom_labeled_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _buttonText = 'Unwrap';

class UnwrapButton extends ConsumerWidget {
  final DigitalAssetModel digitalAsset;
  final Color backgroundColor, borderColor, loadingColor, textColor;
  final Size? size;
  final EdgeInsets padding;
  const UnwrapButton({
    super.key,
    required this.digitalAsset,
    this.backgroundColor = ColorPalette.dReaderYellow100,
    this.borderColor = Colors.transparent,
    this.loadingColor = ColorPalette.appBackgroundColor,
    this.textColor = Colors.black,
    this.padding = const EdgeInsets.symmetric(
      vertical: 4,
      horizontal: 8,
    ),
    this.size,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      unwrapNotifierProvider(digitalAsset.address),
      (previous, next) {
        next.whenOrNull(
          failed: (message) => showSnackBar(
            context: context,
            text: message,
          ),
          success: (message) => nextScreenPush(
            context: context,
            path: RoutePath.openDigitalAssetAnimation,
          ),
          showDialog: () {
            bool isChecked = false;
            return triggerWalkthroughDialog(
              context: context,
              buttonText: _buttonText,
              onSubmit: () async {
                if (isChecked) {
                  LocalStore.instance.put(
                    WalkthroughKeys.unwrap.name,
                    true,
                  );
                }
                context.pop();
                await ref
                    .read(unwrapNotifierProvider(digitalAsset.address).notifier)
                    .unwrapDigitalAsset(
                      digitalAssetAddress: digitalAsset.address,
                      ownerAddress: digitalAsset.ownerAddress,
                      ignoreDialog: true,
                    );
              },
              title: 'Comic unwraping',
              subtitle:
                  'By unwrapping the comic, you will be able to read it. This action is irreversible and will make the comic lose the mint condition.',
              bottomWidget: StatefulBuilder(
                builder: (context, setState) {
                  return CustomLabeledCheckbox(
                    isChecked: isChecked,
                    onChange: () {
                      setState(
                        () {
                          isChecked = !isChecked;
                        },
                      );
                    },
                    label: Text(
                      'Don\'t ask me again',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              ),
              assetPath: '',
            );
          },
          failedWithException: (exception) {
            triggerLowPowerOrNoWallet(
              context,
              exception,
            );
          },
        );
      },
    );
    return ref.watch(unwrapNotifierProvider(digitalAsset.address)).maybeWhen(
          processing: () => _UnwrapButton(
            key: Key(digitalAsset.address),
            isLoading: true,
            digitalAsset: digitalAsset,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            loadingColor: loadingColor,
            textColor: textColor,
            padding: padding,
            size: size,
          ),
          orElse: () => _UnwrapButton(
            key: Key(digitalAsset.address),
            isLoading: false,
            digitalAsset: digitalAsset,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            loadingColor: loadingColor,
            textColor: textColor,
            padding: padding,
            size: size,
          ),
        );
  }
}

class _UnwrapButton extends ConsumerWidget {
  final bool isLoading;
  final DigitalAssetModel digitalAsset;
  final Color backgroundColor, borderColor, loadingColor, textColor;
  final Size? size;
  final EdgeInsets padding;
  const _UnwrapButton({
    super.key,
    required this.isLoading,
    required this.digitalAsset,
    required this.backgroundColor,
    required this.borderColor,
    required this.loadingColor,
    required this.textColor,
    required this.padding,
    this.size,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTextButton(
      key: key,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      loadingColor: loadingColor,
      padding: padding,
      borderRadius: BorderRadius.circular(8),
      textColor: Colors.black,
      size: size ?? const Size(0, 50),
      isLoading: isLoading,
      onPressed: isLoading
          ? null
          : () async {
              await ref
                  .read(unwrapNotifierProvider(digitalAsset.address).notifier)
                  .unwrapDigitalAsset(
                    digitalAssetAddress: digitalAsset.address,
                    ownerAddress: digitalAsset.ownerAddress,
                  );
            },
      child: Text(
        _buttonText,
        style:
            Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor),
      ),
    );
  }
}
