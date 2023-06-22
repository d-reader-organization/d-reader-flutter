import 'package:d_reader_flutter/core/providers/discover/filter_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SortMenu extends ConsumerWidget {
  const SortMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sort By',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: () {
                ref.read(sortDirectionProvider.notifier).update(
                      (state) => state == SortDirection.asc
                          ? SortDirection.desc
                          : SortDirection.asc,
                    );
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorPalette.boxBackground300,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(
                          8,
                        ),
                        bottomLeft: Radius.circular(
                          8,
                        ),
                      ),
                    ),
                    child: Text(
                      ref.watch(sortDirectionProvider) == SortDirection.asc
                          ? 'Lowest first'
                          : 'Highest first',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorPalette.boxBackground300,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(
                          8,
                        ),
                        topRight: Radius.circular(
                          8,
                        ),
                      ),
                    ),
                    child: ref.watch(sortDirectionProvider) == SortDirection.asc
                        ? SvgPicture.asset(
                            'assets/icons/arrow_down.svg',
                          )
                        : RotationTransition(
                            turns: const AlwaysStoppedAnimation(
                              180 / 360,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/arrow_down.svg',
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Column(
          children: const [
            FilterRadioButton(
              title: 'New',
              value: SortByEnum.latest,
            ),
            FilterRadioButton(
              title: 'Rating',
              value: SortByEnum.rating,
            ),
            FilterRadioButton(
              title: 'Likes',
              value: SortByEnum.likes,
            ),
            FilterRadioButton(
              title: 'Readers',
              value: SortByEnum.readers,
            ),
            FilterRadioButton(
              title: 'Viewers',
              value: SortByEnum.viewers,
            ),
          ],
        ),
      ],
    );
  }
}