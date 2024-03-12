import 'package:d_reader_flutter/shared/domain/providers/global/global_providers.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PageNumberWidget extends ConsumerWidget {
  final int pageNumber;
  const PageNumberWidget({
    super.key,
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
      opacity: ref.watch(isAppBarVisibleProvider) ? 1 : 0,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: ColorPalette.appBackgroundColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        child: Text(
          'Page $pageNumber',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
