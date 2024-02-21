import 'package:d_reader_flutter/core/states/pagination_state.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class OnGoingBottomWidget extends StatelessWidget {
  final PaginationState provider;
  final bool sliverWidget;
  const OnGoingBottomWidget({
    super.key,
    required this.provider,
    this.sliverWidget = true,
  });

  @override
  Widget build(BuildContext context) {
    return sliverWidget
        ? SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              child: provider.maybeWhen(
                orElse: () => const SizedBox.shrink(),
                onGoingLoading: (items) {
                  return const Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: ColorPalette.greyscale500,
                      ),
                    ),
                  );
                },
                onGoingError: (items, e, stk) {
                  return const Center(
                    child: Text('Something went wrong.'),
                  );
                },
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: provider.maybeWhen(
              orElse: () => const SizedBox.shrink(),
              onGoingLoading: (items) {
                return const Center(
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: ColorPalette.greyscale500,
                    ),
                  ),
                );
              },
              onGoingError: (items, e, stk) {
                return const Center(
                  child: Text('Something went wrong.'),
                );
              },
            ),
          );
  }
}
