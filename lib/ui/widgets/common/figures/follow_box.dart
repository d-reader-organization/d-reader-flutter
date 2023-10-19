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
        ref.read(creatorRepositoryProvider).followCreator(slug);
        followingHook.value = followingHook.value.copyWith(
          count: followingHook.value.isSelected
              ? followingHook.value.count - 1
              : followingHook.value.count + 1,
          isSelected: !followingHook.value.isSelected,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
            color: ColorPalette.greyscale400,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              followingHook.value.isSelected ? 'Unfollow' : 'Follow',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ColorPalette.greyscale100,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              constraints: const BoxConstraints(minWidth: 32),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  5,
                ),
                color: ColorPalette.greyscale400,
              ),
              child: Text(
                '${followingHook.value.count}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ColorPalette.greyscale100,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
