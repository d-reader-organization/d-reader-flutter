import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_issue_card_large.dart';
import 'package:d_reader_flutter/ui/widgets/common/comic_details_header.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_sliver_app_bar.dart';
import 'package:flutter/material.dart';

class ComicDetails extends StatelessWidget {
  final String slug;
  const ComicDetails({
    Key? key,
    required this.slug,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const CustomSliverAppBar(),
              const ComicDetailsHeader(),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ComicIssueCardLarge(
                  issue: ComicIssueModel(
                    id: 2,
                    number: 10,
                    title: 'Episode $index',
                    slug: 'slug',
                    description:
                        'Gorecats are an eclectic breed of treacherous little trouble makers, hell bent on using every single one of their glorious nine...',
                    cover:
                        'https://d-reader-dev.s3.us-east-1.amazonaws.com/creators/studio-nx/comics/barbabyans/cover.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIA4DWH47RZXHCSECE5%2F20221118%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20221118T084838Z&X-Amz-Expires=3600&X-Amz-Signature=9d10b1fd9d31ac5e62eba9accae29597a58ccef1fc1d075081d1c2878b217e88&X-Amz-SignedHeaders=host&x-id=GetObject',
                    stats: ComicIssueStats(
                        floorPrice: 12, totalSupply: 12, totalVolume: 12),
                    comic: ComicModel(
                      name: 'The Barbayans',
                      slug: 'slug',
                      cover:
                          'https://d-reader-dev.s3.us-east-1.amazonaws.com/creators/studio-nx/comics/barbabyans/cover.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIA4DWH47RZXHCSECE5%2F20221118%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20221118T084838Z&X-Amz-Expires=3600&X-Amz-Signature=9d10b1fd9d31ac5e62eba9accae29597a58ccef1fc1d075081d1c2878b217e88&X-Amz-SignedHeaders=host&x-id=GetObject',
                      description: 'Desc',
                      issues: [],
                      creator: CreatorModel(
                        id: 1,
                        email: 'creator@gmail.com',
                        slug: 'creator',
                        name: 'DefaultCreator',
                        avatar: '',
                        banner: '',
                        description: 'Desc',
                        comics: [],
                        issues: [],
                        stats:
                            CreatorStats(comicIssuesCount: 5, totalVolume: 20),
                      ),
                      stats: ComicStats(
                          favouritesCount: 12,
                          subscribersCount: 12,
                          ratersCount: 12,
                          averageRating: 12,
                          issuesCount: 12,
                          totalVolume: 12,
                          readersCount: 12,
                          viewersCount: 12),
                      isPopular: true,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
