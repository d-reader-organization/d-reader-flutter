import 'package:d_reader_flutter/core/providers/favourite_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FavouriteIconCount extends HookWidget {
  final int favouritesCount;
  final bool isFavourite;
  final Function? onTap;
  const FavouriteIconCount({
    Key? key,
    required this.favouritesCount,
    required this.isFavourite,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final favouriteHook = useFavouriteState(
      FavouriteState(
        count: favouritesCount,
        isFavourite: isFavourite,
      ),
    );
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
        favouriteHook.value = favouriteHook.value.copyWith(
            count: favouriteHook.value.isFavourite
                ? favouriteHook.value.count - 1
                : favouriteHook.value.count + 1,
            isFavourite: !favouriteHook.value.isFavourite);
      },
      child: Row(
        children: [
          Icon(
            favouriteHook.value.isFavourite
                ? CupertinoIcons.heart_fill
                : CupertinoIcons.heart,
            color: favouriteHook.value.isFavourite
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
