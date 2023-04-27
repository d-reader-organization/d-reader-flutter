import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//todo
final commonTextEditingController = StateProvider<TextEditingController>(
  (ref) {
    final TextEditingController controller = TextEditingController();
    ref.onDispose(() {
      controller.dispose();
    });

    return controller;
  },
);

final commonTextValue = StateProvider<String>((ref) {
  return '';
});
