import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/episode_circle.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:flutter/material.dart';

class ComicIssueCard extends StatelessWidget {
  final ComicIssueModel issue;
  const ComicIssueCard({
    Key? key,
    required this.issue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String episode = '${issue.number}/${issue.comic?.issues.length}';
    return Container(
      height: 255,
      width: 175,
      decoration: BoxDecoration(
        color: dReaderDarkGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      issue.cover,
                    ),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(width: 1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(
                      16,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 12,
                top: 16,
                child: EpisodeCircle(text: 'EP $episode'),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(right: 4, left: 8, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.comic?.name ?? 'Missing',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: dReaderYellow,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  issue.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      issue.comic?.creator.name ?? 'Missing',
                      style: Theme.of(context).textTheme.labelMedium,
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
                  height: 8,
                ),
                SolanaPrice(
                  price: issue.floorPrice,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
