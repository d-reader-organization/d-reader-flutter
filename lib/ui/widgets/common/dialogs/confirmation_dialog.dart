import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      backgroundColor: ColorPalette.greyscale400,
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
                    return context.pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: ColorPalette.greyscale500,
                          width: 1,
                        ),
                        top: BorderSide(
                          color: ColorPalette.greyscale500,
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
                          final privateLoadingNotifier =
                              ref.read(privateLoadingProvider.notifier);
                          privateLoadingNotifier.update(
                            (state) => true,
                          );
                          result = await onTap!();
                          if (result is! String) {
                            ref.invalidate(comicIssueDetailsProvider);
                            ref.invalidate(comicSlugProvider);
                          }
                          privateLoadingNotifier.update(
                            (state) => false,
                          );
                        }

                        if (context.mounted) {
                          return context.pop(
                            onTap != null ? result : true,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: ColorPalette.greyscale500,
                              width: 1,
                            ),
                          ),
                        ),
                        child: ref.watch(privateLoadingProvider)
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
