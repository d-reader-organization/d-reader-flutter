import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/details_header_image.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/favourite_icon_count.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/rating_icon.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:d_reader_flutter/ui/widgets/creators/stats_box.dart';
import 'package:flutter/material.dart';

String avatarUrl =
    'https://d-reader-dev.s3.us-east-1.amazonaws.com/creators/studio-nx/avatar.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIA4DWH47RZXHCSECE5%2F20221118%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20221118T095153Z&X-Amz-Expires=3600&X-Amz-Signature=c35b7a4a16ed771ae51bf9ccc1f87aea1c96e940656166a68d401f00ef01cf96&X-Amz-SignedHeaders=host&x-id=GetObject';

class ComicDetailsHeader extends StatelessWidget {
  final bool showAwardText;
  const ComicDetailsHeader({
    Key? key,
    this.showAwardText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          DetailsHeaderImage(
            showAwardText: showAwardText,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CreatorAvatar(
                          avatar: avatarUrl,
                          radius: 24,
                        ),
                        const SizedBox(width: 12),
                        const AuthorVerified(
                          authorName: 'Studio NX',
                          fontSize: 15,
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        RatingIcon(rating: 4.5),
                        SizedBox(
                          width: 20,
                        ),
                        FavouriteIconCount(favouritesCount: 55),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    StatsBox(
                      title: 'TOTAL VOL',
                      stats: '73.42 ',
                      isSmall: true,
                    ),
                    StatsBox(title: 'ISSUES', stats: '6', isSmall: true),
                    StatsBox(title: 'READERS', stats: '4221', isSmall: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
