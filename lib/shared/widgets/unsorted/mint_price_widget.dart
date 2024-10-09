import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/notifiers/candy_machine_notifier.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MintPriceWidget extends ConsumerWidget {
  final Color priceColor;
  const MintPriceWidget({
    super.key,
    this.priceColor = Colors.white,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: ref.watch(activeSplToken)?.icon ?? '',
          height: 18,
          width: 18,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          Formatter.formatPriceByCurrency(
            mintPrice:
                ref.watch(candyMachineNotifierProvider.notifier).getMintPrice(),
            splToken: ref.watch(activeSplToken),
          ),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: priceColor,
              ),
        ),
      ],
    );
  }
}
