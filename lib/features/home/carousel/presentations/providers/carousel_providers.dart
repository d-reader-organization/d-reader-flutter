import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/home/carousel/domain/models/carousel.dart';
import 'package:d_reader_flutter/features/home/carousel/domain/providers/carousel_provider.dart';
import 'package:d_reader_flutter/ui/utils/launch_external_url.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:flutter/material.dart' show BuildContext;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'carousel_providers.g.dart';

final carouselProvider = FutureProvider<List<CarouselModel>>((ref) async {
  return ref.read(carouselRepositoryProvider).getCarouselData();
});

final sliderDotsIndicatorPosition = StateProvider.autoDispose<int>(
  (ref) {
    return 0;
  },
);

@riverpod
class CarouselController extends _$CarouselController {
  @override
  FutureOr<void> build() {}

  handleItemTap({
    required CarouselModel carouselItem,
    required BuildContext context,
  }) {
    if (carouselItem.externalLink != null &&
        carouselItem.externalLink!.isNotEmpty) {
      openUrl(
        carouselItem.externalLink!,
        LaunchMode.inAppWebView,
      );
    } else if (carouselItem.comicSlug != null &&
        carouselItem.comicSlug!.isNotEmpty) {
      return nextScreenPush(
        context: context,
        path: '${RoutePath.comicDetails}/${carouselItem.comicSlug}',
      );
    } else if (carouselItem.comicIssueId != null) {
      return nextScreenPush(
        context: context,
        path: '${RoutePath.comicIssueDetails}/${carouselItem.comicIssueId}',
      );
    } else if (carouselItem.creatorSlug != null &&
        carouselItem.creatorSlug!.isNotEmpty) {
      return nextScreenPush(
        context: context,
        path: '${RoutePath.creatorDetails}/${carouselItem.creatorSlug}',
      );
    }
  }
}
