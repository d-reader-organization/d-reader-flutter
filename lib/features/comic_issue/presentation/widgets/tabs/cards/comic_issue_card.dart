import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/shared/widgets/icons/hot_icon.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/price_widget.dart';
import 'package:flutter/material.dart';

class ComicIssueCard extends StatelessWidget {
  final ComicIssueModel issue;

  const ComicIssueCard({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.comicIssueDetails}/${issue.id}',
        );
      },
      child: Stack(
        children: [
          _IssueCoverBgContainer(issue: issue),
          _IssueInfoContainer(
            issue: issue,
          ),
        ],
      ),
    );
  }
}

class _IssueCoverBgContainer extends StatelessWidget {
  final ComicIssueModel issue;
  const _IssueCoverBgContainer({required this.issue});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: comicIssueAspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CachedImageBgPlaceholder(
            imageUrl: issue.cover,
            padding: EdgeInsets.zero,
            cacheHeight: constraints.maxHeight.cacheSize(context),
            cacheWidth: constraints.maxWidth.cacheSize(context),
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                colors: [
                  ColorPalette.greyscale500,
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.0, .5],
              ),
            ),
            child: issue.isPopular
                ? const Align(
                    alignment: Alignment.topLeft,
                    child: HotIconSmall(),
                  )
                : null,
          );
        },
      ),
    );
  }
}

class _IssueInfoContainer extends StatelessWidget {
  final ComicIssueModel issue;
  const _IssueInfoContainer({required this.issue});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            issue.comic?.title ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: textTheme.bodySmall?.copyWith(
              color: ColorPalette.greyscale100,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            issue.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium,
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'EP ${issue.number}/${issue.stats?.totalIssuesCount}',
                style: textTheme.bodySmall,
              ),
              PriceWidget(
                price: Formatter.formatLamportPrice(issue.stats?.price),
                mainAxisAlignment: MainAxisAlignment.end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
