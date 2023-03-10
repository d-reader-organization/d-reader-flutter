import 'package:d_reader_flutter/core/providers/count_provider.dart';
import 'package:d_reader_flutter/core/providers/creator_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FollowBox extends HookConsumerWidget {
  final int followersCount;
  final bool isFollowing;
  final String slug;
  const FollowBox({
    super.key,
    required this.followersCount,
    required this.isFollowing,
    required this.slug,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followingHook = useCountState(
      CountState(
        count: followersCount,
        isSelected: isFollowing,
      ),
    );
    return GestureDetector(
      onTap: () {
        ref.read(followCreatorProvider(slug));
        followingHook.value = followingHook.value.copyWith(
          count: followingHook.value.isSelected
              ? followingHook.value.count - 1
              : followingHook.value.count + 1,
          isSelected: !followingHook.value.isSelected,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(minWidth: 148),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: ColorPalette.boxBackground300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.person_add,
                  size: 20,
                  color: ColorPalette.dReaderGrey,
                ),
                const SizedBox(
                  width: 6,
                ),
                Text(
                  followingHook.value.isSelected ? 'Unfollow' : 'Follow',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: ColorPalette.dReaderGrey,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                ),
                const SizedBox(
                  width: 6,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  4,
                ),
                color: followingHook.value.isSelected
                    ? ColorPalette.dReaderGrey
                    : ColorPalette.boxBackground300,
              ),
              child: Text(
                '${followingHook.value.count}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: followingHook.value.isSelected
                          ? ColorPalette.boxBackground300
                          : ColorPalette.dReaderGrey,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
