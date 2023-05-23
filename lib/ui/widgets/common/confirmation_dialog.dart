import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? additionalChild;
  final Future Function()? onTap;
  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.additionalChild,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorPalette.boxBackground300,
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                if (additionalChild != null) additionalChild!
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    return Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: ColorPalette.boxBackground200,
                          width: 1,
                        ),
                        top: BorderSide(
                          color: ColorPalette.boxBackground200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorPalette.dReaderYellow100,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        dynamic result;
                        if (onTap != null) {
                          final globalStateNotifier =
                              ref.read(globalStateProvider.notifier);
                          globalStateNotifier.update(
                            (state) => state.copyWith(
                              isLoading: true,
                            ),
                          );
                          result = await onTap!();
                          if (result is! String) {
                            ref.invalidate(comicIssueDetailsProvider);
                            ref.invalidate(comicSlugProvider);
                          }
                          globalStateNotifier.update(
                            (state) => state.copyWith(
                              isLoading: false,
                            ),
                          );
                        }

                        if (context.mounted) {
                          return Navigator.pop(context, result);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: ColorPalette.boxBackground200,
                              width: 1,
                            ),
                          ),
                        ),
                        child: ref.watch(globalStateProvider).isLoading
                            ? const Center(
                                child: SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: ColorPalette.appBackgroundColor,
                                  ),
                                ),
                              )
                            : const Text(
                                'OK',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorPalette.dReaderYellow100,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
