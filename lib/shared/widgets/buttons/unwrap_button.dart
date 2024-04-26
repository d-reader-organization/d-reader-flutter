import 'package:d_reader_flutter/constants/enums.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/shared/data/local/local_store.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/shared/widgets/checkbox/custom_labeled_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UnwrapButton extends ConsumerWidget {
  final bool isLoading;
  final NftModel nft;
  final Color backgroundColor, borderColor, loadingColor, textColor;
  final Size? size;
  final EdgeInsets padding;
  final Future<void> Function() onPressed;
  const UnwrapButton({
    super.key,
    required this.isLoading,
    required this.nft,
    required this.onPressed,
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
    return CustomTextButton(
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
              final shouldTriggerDialog =
                  LocalStore.instance.get(WalkthroughKeys.unwrap.name) == null;
              if (!shouldTriggerDialog) {
                return await onPressed();
              }

              bool isChecked = false;
              return triggerWalkthroughDialog(
                context: context,
                buttonText: 'Unwrap',
                onSubmit: () async {
                  if (isChecked) {
                    LocalStore.instance.put(
                      WalkthroughKeys.unwrap.name,
                      true,
                    );
                  }
                  context.pop();
                  await onPressed();
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
      child: Text(
        'Unwrap',
        style:
            Theme.of(context).textTheme.titleMedium?.copyWith(color: textColor),
      ),
    );
  }
}
