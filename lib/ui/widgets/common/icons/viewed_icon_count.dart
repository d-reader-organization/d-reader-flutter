import 'package:d_reader_flutter/core/providers/count_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ViewedIconCount extends HookConsumerWidget {
  final int viewedCount;
  final bool isViewed;
  const ViewedIconCount({
    Key? key,
    required this.viewedCount,
    required this.isViewed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewedCountHook = useCountState(
      CountState(
        count: viewedCount,
        isSelected: isViewed,
      ),
    );
    return InkWell(
      onTap: () {
        viewedCountHook.value = viewedCountHook.value.copyWith(
          count: viewedCountHook.value.isSelected
              ? viewedCountHook.value.count - 1
              : viewedCountHook.value.count + 1,
          isSelected: !viewedCountHook.value.isSelected,
        );
      },
      child: Row(
        children: [
          Icon(
            viewedCountHook.value.isSelected
                ? Icons.remove_red_eye
                : Icons.remove_red_eye_outlined,
            color: const Color(0xFFE0e0e0),
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            viewedCountHook.value.count.toString(),
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: ColorPalette.dReaderGrey),
          )
        ],
      ),
    );
  }
}
