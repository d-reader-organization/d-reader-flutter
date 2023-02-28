import 'package:d_reader_flutter/core/providers/comic_provider.dart';
import 'package:d_reader_flutter/core/providers/count_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum Variant { filled, blank }

class FavouriteIconCount extends HookConsumerWidget {
  final int favouritesCount;
  final bool isFavourite;
  final String slug;
  final Variant variant;
  const FavouriteIconCount({
    Key? key,
    required this.favouritesCount,
    required this.isFavourite,
    required this.slug,
    this.variant = Variant.blank,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final favouriteHook = useCountState(
      CountState(
        count: favouritesCount,
        isSelected: isFavourite,
      ),
    );
    return InkWell(
      onTap: () {
        ref.read(updateComicFavouriteProvider(slug));
        favouriteHook.value = favouriteHook.value.copyWith(
            count: favouriteHook.value.isSelected
                ? favouriteHook.value.count - 1
                : favouriteHook.value.count + 1,
            isSelected: !favouriteHook.value.isSelected);
      },
      child: variant == Variant.filled
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  64,
                ),
              ),
              child: Icon(
                favouriteHook.value.isSelected
                    ? CupertinoIcons.heart_fill
                    : CupertinoIcons.heart,
                color: favouriteHook.value.isSelected
                    ? ColorPalette.dReaderRed
                    : ColorPalette.dReaderGrey,
                size: 16,
              ),
            )
          : Row(
              children: [
                Icon(
                  favouriteHook.value.isSelected
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: favouriteHook.value.isSelected
                      ? ColorPalette.dReaderRed
                      : ColorPalette.dReaderGrey,
                  size: 16,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  favouriteHook.value.count.toString(),
                  style: textTheme.labelMedium,
                ),
              ],
            ),
    );
  }
}
