import 'package:d_reader_flutter/core/models/details_scaffold_model.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_date.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/description_text.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/hot_icon.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tags.dart';
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
          foregroundDecoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.transparent,
                Colors.black,
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.05, 0.3, 1, 0.7],
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
                                    '${data.episodeNumber ?? 0}',
                                    style: textTheme.bodyLarge,
                                  ),
                                  Text(
                                    '/${data.generalStats.totalIssuesCount}',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: ColorPalette.dReaderGrey
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                data.title,
                                style: textTheme.titleSmall?.copyWith(
                                  color: ColorPalette.dReaderYellow100,
                                ),
                              ),
                              Text(
                                data.subtitle,
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
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  width: 3,
                                  color: ColorPalette.dReaderYellow100,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            data.flavorText ?? '',
                            style: textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 12,
                ),
                DescriptionText(
                  text: data.description,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 8,
                ),
                GenreTags(genres: data.genres ?? []),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
