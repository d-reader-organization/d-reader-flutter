import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/core/models/carousel.dart';
import 'package:d_reader_flutter/core/providers/dio/dio_provider.dart';
import 'package:d_reader_flutter/core/repositories/carousel/carousel_repository_impl.dart';
import 'package:d_reader_flutter/ui/utils/launch_external_url.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';
part 'carousel_provider.g.dart';

final carouselRepositoryProvider = Provider<CarouselRepositoryImpl>((ref) {
  return CarouselRepositoryImpl(
    client: ref.watch(dioProvider),
  );
});

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
