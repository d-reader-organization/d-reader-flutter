import 'package:carousel_slider/carousel_slider.dart';
import 'package:d_reader_flutter/core/models/carousel.dart';
import 'package:d_reader_flutter/core/providers/carousel_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/launch_external_url.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/comic_details.dart';
import 'package:d_reader_flutter/ui/views/comic_issue_details.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Carousel extends ConsumerWidget {
  const Carousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<CarouselModel>> carouselData = ref.watch(carouselProvider);
    TextTheme textTheme = Theme.of(context).textTheme;
    return carouselData.when(
      data: (data) {
        return CarouselSlider(
          options: CarouselOptions(
            height: 266.0,
            viewportFraction: 1,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(
              seconds: 5,
            ),
          ),
          items: data
              .map(
                (carouselItem) => GestureDetector(
                  onTap: () {
                    if (carouselItem.externalLink != null &&
                        carouselItem.externalLink!.isNotEmpty) {
                      openUrl(carouselItem.externalLink!);
                    } else if (carouselItem.comicSlug != null &&
                        carouselItem.comicSlug!.isNotEmpty) {
                      return nextScreenPush(
                          context, ComicDetails(slug: carouselItem.comicSlug!));
                    } else if (carouselItem.comicIssueId != null) {
                      return nextScreenPush(context,
                          ComicIssueDetails(id: carouselItem.comicIssueId!));
                    } else if (carouselItem.creatorSlug != null &&
                        carouselItem.creatorSlug!.isNotEmpty) {
                      return nextScreenPush(context,
                          CreatorDetailsView(slug: carouselItem.creatorSlug!));
                    }
                  },
                  child: Stack(
                    children: [
                      CachedImageBgPlaceholder(
                        height: 266,
                        imageUrl: carouselItem.image,
                        cacheKey: '${carouselItem.id}${carouselItem.title}',
                        foregroundDecoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              ColorPalette.boxBackground200,
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [0, 0.8],
                          ),
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        bottom: 20,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              carouselItem.subtitle,
                              style: textTheme.bodySmall,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              carouselItem.title,
                              style: textTheme.headlineLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
      error: (err, stack) => Text(
        'Error: $err',
        style: const TextStyle(color: Colors.red),
      ),
      loading: () => const SkeletonCard(
        height: 266,
        width: double.infinity,
      ),
    );
  }
}
