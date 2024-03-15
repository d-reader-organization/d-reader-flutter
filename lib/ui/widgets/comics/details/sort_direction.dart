import 'package:d_reader_flutter/features/discover/root/presentation/providers/filter_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/ui/widgets/comics/details/filter_and_sort.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SortDirectionContainer extends ConsumerWidget {
  const SortDirectionContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(comicSortDirectionProvider.notifier).update(
              (state) => state == SortDirection.asc
                  ? SortDirection.desc
                  : SortDirection.asc,
            );
      },
      child: BodyFilterAndSortContainer(
        child: Row(
          children: [
            const Text(
              'Ep No',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            ref.watch(comicSortDirectionProvider) == SortDirection.asc
                ? SvgPicture.asset(
                    'assets/icons/arrow_down.svg',
                    height: 18,
                    width: 18,
                  )
                : RotationTransition(
                    turns: const AlwaysStoppedAnimation(
                      180 / 360,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/arrow_down.svg',
                      height: 18,
                      width: 18,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
