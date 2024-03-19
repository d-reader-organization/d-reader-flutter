import 'package:d_reader_flutter/shared/domain/providers/internet_access_provider.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/carrot_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Widget renderCarrotErrorWidget(WidgetRef ref) {
  return ref.watch(internetAccessProvider).when(
    data: (hasInternet) {
      return CarrotErrorWiddget(
        mainErrorText:
            hasInternet ? 'Something broke!' : 'No internet connection',
      );
    },
    error: (error, stackTrace) {
      return const SizedBox();
    },
    loading: () {
      return const SizedBox();
    },
  );
}
