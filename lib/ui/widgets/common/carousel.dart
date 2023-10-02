import 'package:carousel_slider/carousel_slider.dart';
import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/carousel.dart';
import 'package:d_reader_flutter/core/providers/carousel_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/launch_external_url.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/comic_details/comic_details.dart';
import 'package:d_reader_flutter/ui/views/comic_issue_details2.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Carousel extends ConsumerWidget {
  const Carousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<CarouselModel>> carouselData = ref.watch(carouselProvider);
    TextTheme textTheme = Theme.of(context).textTheme;
    return carouselData.when(
      data: (data) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 12, left: 12),
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(
                Config.whiteLogoPath,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  ref
                      .read(sliderDotsIndicatorPosition.notifier)
                      .update((state) => index);
                },
                height: 320,
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
                          return nextScreenPush(context,
                              ComicDetails(slug: carouselItem.comicSlug!));
                        } else if (carouselItem.comicIssueId != null) {
                          return nextScreenPush(
                              context,
                              ComicIssueDetails2(
                                  id: carouselItem.comicIssueId!));
                        } else if (carouselItem.creatorSlug != null &&
                            carouselItem.creatorSlug!.isNotEmpty) {
                          return nextScreenPush(
                              context,
                              CreatorDetailsView(
                                  slug: carouselItem.creatorSlug!));
                        }
                      },
                      child: Stack(
                        children: [
                          CachedImageBgPlaceholder(
                            height: 320,
                            imageUrl: carouselItem.image,
                            borderRadius: 0,
                            foregroundDecoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ColorPalette.appBackgroundColor,
                                  Color.fromRGBO(31, 34, 42, 0.0),
                                  ColorPalette.appBackgroundColor,
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                stops: [
                                  0,
                                  .4236,
                                  1.0,
                                ],
                              ),
                            ),
                          ),
                          Positioned.fill(
                            bottom: 20,
                            left: 16,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: data.asMap().entries.map((entry) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 4.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ref.watch(sliderDotsIndicatorPosition) == entry.key
                        ? const Color(0xFFD9D9D9)
                        : ColorPalette.boxBackground300,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
      error: (err, stack) => Text(
        'Error: $err',
        style: const TextStyle(color: Colors.red),
      ),
      loading: () => const SkeletonCard(
        height: 320,
        width: double.infinity,
      ),
    );
  }
}
