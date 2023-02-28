import 'package:d_reader_flutter/core/models/details_scaffold_model.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_date.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/hot_icon.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_with_view_more.dart';
import 'package:flutter/material.dart';

class DetailsHeaderImage extends StatelessWidget {
  final bool isComicDetails;
  final DetailsScaffoldModel data;
  const DetailsHeaderImage({
    Key? key,
    required this.isComicDetails,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        CachedImageBgPlaceholder(
          height: 364,
          imageUrl: data.imageUrl,
          cacheKey: 'details-${data.slug}',
          overrideBorderRadius: BorderRadius.circular(0),
          foregroundDecoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorPalette.appBackgroundColor,
                Colors.transparent,
                ColorPalette.appBackgroundColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.128, .6406, 1],
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isComicDetails
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.title,
                            style: textTheme.headlineLarge,
                          ),
                          data.generalStats.isPopular ?? false
                              ? const HotIcon()
                              : const SizedBox(),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EPISODE',
                                style: textTheme.bodyMedium,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${data.episodeNumber}',
                                    style: textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    '/${data.generalStats.totalIssuesCount}',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: ColorPalette.dReaderGrey
                                          .withOpacity(0.5),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${data.generalStats.totalPagesCount.toString()} pages',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                data.subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.headlineLarge,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                formatDate(data.releaseDate!),
                                style: textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 8,
                ),
                isComicDetails
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left: 8),
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 3,
                                    color: ColorPalette.dReaderYellow100,
                                  ),
                                ),
                              ),
                              child: Text(
                                data.flavorText ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 12,
                ),
                TextWithViewMore(
                  text: data.description,
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
