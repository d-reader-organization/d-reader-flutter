import 'package:d_reader_flutter/features/discover/root/presentation/providers/filter_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/presentations/providers/common/tab_bar_provider.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/radio_button.dart';
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
            Text(
              'Sort By',
              style: Theme.of(context).textTheme.headlineMedium,
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
                        color: ColorPalette.greyscale400,
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
                    padding: const EdgeInsets.all(6.5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: ColorPalette.greyscale400,
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
          height: 16,
        ),
        if (ref.watch(tabBarProvider) == 2)
          const _CreatorSortMenu()
        else
          const _DefaultSortMenu()
      ],
    );
  }
}

class _DefaultSortMenu extends StatelessWidget {
  const _DefaultSortMenu();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomRadioButton(
          title: SortByEnum.latest.displayText(),
          value: SortByEnum.latest,
        ),
        CustomRadioButton(
          title: SortByEnum.rating.displayText(),
          value: SortByEnum.rating,
        ),
        CustomRadioButton(
          title: SortByEnum.likes.displayText(),
          value: SortByEnum.likes,
        ),
        CustomRadioButton(
          title: SortByEnum.readers.displayText(),
          value: SortByEnum.readers,
        ),
        CustomRadioButton(
          title: SortByEnum.viewers.displayText(),
          value: SortByEnum.viewers,
        ),
      ],
    );
  }
}

class _CreatorSortMenu extends StatelessWidget {
  const _CreatorSortMenu();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomRadioButton(
          title: SortByEnum.name.displayText(),
          value: SortByEnum.name,
        ),
        CustomRadioButton(
          title: SortByEnum.followers.displayText(),
          value: SortByEnum.followers,
        ),
      ],
    );
  }
}
