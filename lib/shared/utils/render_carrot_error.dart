import 'package:d_reader_flutter/shared/domain/providers/internet_access_provider.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/carrot_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const String _noInternetMessage = 'No internet connection';

Widget renderCarrotErrorWidget(WidgetRef ref) {
  return ref.watch(internetAccessProvider).when(
    data: (hasInternet) {
      return CarrotErrorWidget(
        mainErrorText: hasInternet ? defaultErrorMessage : _noInternetMessage,
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
