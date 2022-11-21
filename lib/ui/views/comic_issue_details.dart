import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_card_for_sale.dart';
import 'package:d_reader_flutter/ui/widgets/details_scaffold.dart';
import 'package:flutter/material.dart';

class ComicIssueDetails extends StatelessWidget {
  final String slug;
  const ComicIssueDetails({
    Key? key,
    required this.slug,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DetailsScaffold(
      showAwardText: false,
      body: GridView.builder(
        itemCount: 5,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          mainAxisExtent: 198,
        ),
        itemBuilder: (context, index) {
          return ComicCardForSale(
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
                isCompleted: true,
                creator: CreatorModel(
                  id: 1,
                  email: 'creator@gmail.com',
                  slug: 'creator',
                  name: 'DefaultCreator',
                  avatar: '',
                  banner: '',
                  description: 'Desc',
                  stats: CreatorStats(comicIssuesCount: 5, totalVolume: 20),
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
    );
  }
}
