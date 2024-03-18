import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ListingFilters extends ConsumerStatefulWidget {
  const ListingFilters({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListingFiltersState();
}

class _ListingFiltersState extends ConsumerState<ListingFilters> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
                constraints: const BoxConstraints(minHeight: 46),
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: SvgPicture.asset(
                    'assets/icons/search.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                filled: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                fillColor: ColorPalette.greyscale500,
                hintText: '#1203...',
                hintStyle: const TextStyle(
                  color: ColorPalette.greyscale200,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: ColorPalette.greyscale300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: ColorPalette.greyscale300,
                  ),
                )),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 46),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: ColorPalette.greyscale500,
                border: Border.all(
                  color: ColorPalette.greyscale300,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: .2,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/arrow_down.svg',
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Container(
              constraints: const BoxConstraints(minHeight: 46),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorPalette.greyscale500,
                border: Border.all(
                  color: ColorPalette.greyscale300,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                'assets/icons/filter.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
