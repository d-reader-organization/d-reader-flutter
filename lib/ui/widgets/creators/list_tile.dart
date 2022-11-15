import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/cover_cached_image.dart';
import 'package:flutter/material.dart';

class CreatorListTile extends StatelessWidget {
  final CreatorModel creator;
  const CreatorListTile({
    Key? key,
    required this.creator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreenPush(context, CreatorDetailsView(slug: creator.slug));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: dReaderBlack,
              child: CommonCachedImage(
                imageUrl: creator.avatar,
                fit: BoxFit.scaleDown,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      creator.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Icon(
                      Icons.verified,
                      color: dReaderYellow,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  '${creator.stats.totalVolume} %',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: dReaderGreen),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
