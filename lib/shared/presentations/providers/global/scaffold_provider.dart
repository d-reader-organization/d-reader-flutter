import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final scaffoldPageController = Provider.autoDispose<PageController>((ref) {
  final PageController pageController = PageController();
  ref.onDispose(() {
    pageController.dispose();
  });

  return pageController;
});

final scaffoldNavigationIndexProvider = StateProvider(
  (ref) {
    return 0;
  },
);
