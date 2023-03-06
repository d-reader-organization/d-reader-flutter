import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:flutter/material.dart';

class CreatorListTile extends StatelessWidget {
  final CreatorModel creator;
  const CreatorListTile({
    Key? key,
    required this.creator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        nextScreenPush(context, CreatorDetailsView(slug: creator.slug));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          children: [
            CreatorAvatar(
              avatar: creator.avatar,
              slug: creator.slug,
              radius: 48,
              width: 48,
              height: 48,
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthorVerified(
                  authorName: creator.name,
                  isVerified: creator.isVerified,
                  fontSize: 14,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  '${creator.stats?.totalVolume} %',
                  style: textTheme.labelLarge
                      ?.copyWith(color: ColorPalette.dReaderGreen),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
