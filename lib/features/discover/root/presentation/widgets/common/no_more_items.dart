import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/domain/providers/pagination_notifier.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoMoreItemsWidget extends ConsumerWidget {
  final StateNotifierProviderFamily<PaginationNotifier, PaginationState,
      String?> listenableProvider;
  final String query;

  final bool isSliver;
  const NoMoreItemsWidget({
    super.key,
    required this.listenableProvider,
    required this.query,
    this.isSliver = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return isSliver
        ? SliverToBoxAdapter(
            child: ref.watch(listenableProvider(query)).maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  data: (items) {
                    return ref.read(listenableProvider(query).notifier).isEnd
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 32),
                            child: Text(
                              items.isEmpty
                                  ? 'No results found'
                                  : '${items.length} ${pluralizeString(items.length, 'result')} found',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
          )
        : ref.watch(listenableProvider(query)).maybeWhen(
              orElse: () => const SizedBox.shrink(),
              data: (items) {
                return ref.read(listenableProvider(query).notifier).isEnd
                    ? Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 32),
                        child: Text(
                          items.isEmpty
                              ? 'No results found'
                              : '${items.length} ${pluralizeString(items.length, 'result')} found',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : const SizedBox.shrink();
              },
            );
  }
}
