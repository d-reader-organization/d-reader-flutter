import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/digital_asset/domain/models/digital_asset.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/widgets/modal_bottom_sheet.dart';
import 'package:d_reader_flutter/features/transaction/presentation/providers/list/notifier/list_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/solana_providers.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListOrDelistButton extends ConsumerWidget {
  final bool isListButton;
  final DigitalAssetModel digitalAsset;

  const ListOrDelistButton({
    super.key,
    required this.isListButton,
    required this.digitalAsset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      listNotifierProvider,
      (previous, next) {
        next.whenOrNull(
          failed: (message) => showSnackBar(
            context: context,
            text: message,
            backgroundColor: ColorPalette.dReaderRed,
          ),
          failedWithException: (exception) => triggerLowPowerOrNoWallet(
            context,
            exception,
          ),
          success: (message) => showSnackBar(
            context: context,
            text: message,
            backgroundColor: ColorPalette.dReaderGreen,
          ),
        );
      },
    );
    return isListButton
        ? ref.watch(listNotifierProvider).maybeWhen(
              processing: () => _ListButton(
                isLoading: true,
                digitalAsset: digitalAsset,
              ),
              orElse: () => _ListButton(
                isLoading: false,
                digitalAsset: digitalAsset,
              ),
            )
        : ref.watch(listNotifierProvider).maybeWhen(
              processing: () => _DelistButton(
                isLoading: true,
                onPressed: () async {
                  await ref
                      .read(listNotifierProvider.notifier)
                      .delist(digitalAsset.address);
                },
              ),
              orElse: () => _DelistButton(
                isLoading: false,
                onPressed: () async {
                  await ref
                      .read(listNotifierProvider.notifier)
                      .delist(digitalAsset.address);
                },
              ),
            );
  }
}

class ReadButton extends ConsumerWidget {
  final DigitalAssetModel digitalAsset;
  const ReadButton({
    super.key,
    required this.digitalAsset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _Button(
      borderColor: ColorPalette.dReaderYellow100,
      isLoading: ref.watch(globalNotifierProvider).isLoading,
      loadingColor: ColorPalette.dReaderYellow100,
      onPressed: () async {
        return nextScreenPush(
          context: context,
          path: '${RoutePath.eReader}/${digitalAsset.comicIssueId}',
        );
      },
      child: Text(
        'Read',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: ColorPalette.dReaderYellow100,
            ),
      ),
    );
  }
}

class _DelistButton extends StatelessWidget {
  final bool isLoading;
  final Future<void> Function() onPressed;
  const _DelistButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _Button(
      isLoading: isLoading,
      loadingColor: ColorPalette.greyscale200,
      onPressed: onPressed,
      child: Text(
        'Delist',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: ColorPalette.greyscale200,
            ),
      ),
    );
  }
}

class _ListButton extends StatelessWidget {
  final bool isLoading;
  final DigitalAssetModel digitalAsset;
  const _ListButton({
    required this.isLoading,
    required this.digitalAsset,
  });

  @override
  Widget build(BuildContext context) {
    return _Button(
      isLoading: isLoading,
      loadingColor: ColorPalette.greyscale200,
      onPressed: () async {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: DigitalAssetModalBottomSheet(digitalAsset: digitalAsset),
            );
          },
        );
      },
      child: Text(
        'List',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: ColorPalette.greyscale200,
            ),
      ),
    );
  }
}

class _Button extends ConsumerWidget {
  final Widget child;
  final bool isLoading;
  final Future<void> Function() onPressed;
  final Color borderColor, loadingColor;
  const _Button({
    required this.child,
    required this.onPressed,
    this.isLoading = false,
    this.borderColor = ColorPalette.greyscale200,
    this.loadingColor = ColorPalette.appBackgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTextButton(
      size: Size(MediaQuery.sizeOf(context).width / 2.4, 40),
      borderRadius: const BorderRadius.all(
        Radius.circular(
          8,
        ),
      ),
      borderColor: borderColor,
      padding: const EdgeInsets.symmetric(vertical: 8),
      backgroundColor: Colors.transparent,
      isLoading: isLoading,
      onPressed: ref.watch(isOpeningSessionProvider) ? null : onPressed,
      loadingColor: loadingColor,
      child: child,
    );
  }
}
