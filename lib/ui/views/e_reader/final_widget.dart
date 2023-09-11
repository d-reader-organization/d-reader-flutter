import 'package:d_reader_flutter/core/models/page_model.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/views/e_reader/pinch_zoom.dart';
import 'package:d_reader_flutter/ui/views/e_reader/touch_count_recognizer.dart';
import 'package:d_reader_flutter/ui/widgets/common/cover_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final myProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
  return MyNotifier();
});

class MyState {
  final bool isScrolling, isMultiTouch, isZoomed;

  MyState({
    required this.isScrolling,
    required this.isMultiTouch,
    required this.isZoomed,
  });

  MyState copyWith({bool? scrolling, bool? multitouch, bool? zoom}) {
    return MyState(
      isScrolling: scrolling ?? isScrolling,
      isMultiTouch: multitouch ?? isMultiTouch,
      isZoomed: zoom ?? isZoomed,
    );
  }
}

class MyNotifier extends StateNotifier<MyState> {
  MyNotifier()
      : super(
          MyState(
            isScrolling: false,
            isMultiTouch: false,
            isZoomed: false,
          ),
        );

  void startScrolling() {
    state = state.copyWith(scrolling: true);
  }

  void startMultitouch() {
    state = state.copyWith(multitouch: true);
  }

  void startZoom() {
    state = state.copyWith(zoom: true);
  }

  void stopScrolling() {
    state = state.copyWith(scrolling: false);
  }

  void stopZoom() {
    state = state.copyWith(zoom: false);
  }

  void stopMultitouch() {
    state = state.copyWith(multitouch: false);
  }

  void onMultiTouchUpdated(bool newState) {
    state = state.copyWith(multitouch: newState);
  }
}

class FinalWidget extends ConsumerWidget {
  final List<PageModel> pages;
  const FinalWidget({
    super.key,
    required this.pages,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    final myProviderNotifier = ref.watch(myProvider.notifier);
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        TouchCountRecognizer:
            GestureRecognizerFactoryWithHandlers<TouchCountRecognizer>(
          () => TouchCountRecognizer(
            myProviderNotifier.onMultiTouchUpdated,
          ),
          (TouchCountRecognizer instance) {},
        ),
      },
      child: NotificationListener(
        onNotification: (notification) {
          if (notification is ScrollNotification) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              myProviderNotifier.startScrolling();

              if (state.isScrolling == true && state.isMultiTouch == false) {
                myProviderNotifier.stopZoom();
              } else if (state.isScrolling == false &&
                  state.isMultiTouch == true) {
                myProviderNotifier.stopZoom();
              } else if (state.isScrolling == true &&
                  state.isMultiTouch == true) {
                myProviderNotifier.startZoom();
              }
            });
          }
          if (notification is ScrollUpdateNotification) {}
          if (notification is ScrollEndNotification) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              myProviderNotifier.stopScrolling();

              if (state.isScrolling == true && state.isMultiTouch == false) {
                myProviderNotifier.stopZoom();
              } else if (state.isScrolling == false &&
                  state.isMultiTouch == true) {
                myProviderNotifier.stopZoom();
              } else if (state.isScrolling == true &&
                  state.isMultiTouch == true) {
                myProviderNotifier.startZoom();
              }
            });
          }

          return state.isScrolling;
        },
        child: ListView.builder(
          shrinkWrap: true,
          // physics: state.imagePagerScrollPhysics,
          physics: state.isZoomed
              ? const NeverScrollableScrollPhysics()
              : const PageScrollPhysics(),
          itemCount: pages.length,
          itemBuilder: (context, index) {
            return PinchZooming(
              zoomEnabled: true,
              onZoomStart: () => myProviderNotifier.startZoom(),
              onZoomEnd: () => myProviderNotifier.stopZoom(),
              child: CommonCachedImage(
                placeholder: Container(
                  height: 400,
                  width: double.infinity,
                  color: ColorPalette.boxBackground300,
                ),
                imageUrl: pages[index].image,
              ),
            );
          },
        ),
      ),
    );
  }
}
