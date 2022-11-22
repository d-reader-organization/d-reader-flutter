import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_issue_card_large.dart';
import 'package:flutter/material.dart';

List<ComicIssueModel> comicIssues = [
  ComicIssueModel(
    id: 1,
    number: 10,
    title: 'Title',
    slug: 'my-issue-slug',
    description: 'Hey this is an overall issue',
    cover:
        'https://d-reader-dev.s3.us-east-1.amazonaws.com/creators/studio-nx/comics/gorecats/issues/rise-of-the-gorecats/cover.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIA4DWH47RZXHCSECE5%2F20221119%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20221119T112630Z&X-Amz-Expires=3600&X-Amz-Signature=adab699e7bfcaf7b3b10026e3660d6767fdcdfae290db5445572efb98d45f6ca&X-Amz-SignedHeaders=host&x-id=GetObject',
    stats: ComicIssueStats(floorPrice: 12, totalSupply: 15, totalVolume: 15),
    comic: ComicModel(
      name: 'name',
      slug: 'sluggy',
      cover:
          'https://d-reader-dev.s3.us-east-1.amazonaws.com/creators/studio-nx/comics/gorecats/issues/rise-of-the-gorecats/cover.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIA4DWH47RZXHCSECE5%2F20221119%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20221119T112630Z&X-Amz-Expires=3600&X-Amz-Signature=adab699e7bfcaf7b3b10026e3660d6767fdcdfae290db5445572efb98d45f6ca&X-Amz-SignedHeaders=host&x-id=GetObject',
      description: 'Desc',
      isCompleted: true,
      creator: CreatorModel(
          id: 1,
          slug: 'sluggaa2',
          name: 'nane',
          avatar: '',
          isVerified: true,
          banner: '',
          description: '',
          stats: CreatorStats(comicIssuesCount: 5, totalVolume: 5)),
      stats: ComicStats(
          favouritesCount: 5,
          subscribersCount: 5,
          ratersCount: 5,
          averageRating: 5,
          issuesCount: 5,
          totalVolume: 5,
          readersCount: 5,
          viewersCount: 5),
      isPopular: true,
    ),
  ),
];

class CreatorIssuesTab extends StatelessWidget {
  const CreatorIssuesTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comicIssues.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ComicIssueCardLarge(
          issue: comicIssues[index],
        );
      },
    );
  }
}
