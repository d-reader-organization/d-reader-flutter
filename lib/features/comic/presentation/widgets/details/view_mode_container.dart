import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/features/comic/presentation/widgets/details/filter_and_sort.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ViewModeContainer extends ConsumerWidget {
  const ViewModeContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(comicViewModeProvider.notifier).update((state) =>
            state == ViewMode.detailed ? ViewMode.gallery : ViewMode.detailed);
      },
      child: BodyFilterAndSortContainer(
          child: Row(
        children: [
          const Text(
            'View',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          ref.watch(comicViewModeProvider) == ViewMode.detailed
              ? SvgPicture.asset('assets/icons/category.svg')
              : SvgPicture.asset('assets/icons/list.svg'),
        ],
      )),
    );
  }
}
