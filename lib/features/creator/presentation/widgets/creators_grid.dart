import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/features/creator/presentation/providers/creator_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/features/creator/presentation/widgets/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreatorsGrid extends ConsumerWidget {
  final String? query;
  const CreatorsGrid({
    super.key,
    this.query,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isTablet = MediaQuery.sizeOf(context).width > 600;
    AsyncValue<List<CreatorModel>> creators =
        ref.watch(creatorsProvider(query));

    return creators.when(
      data: (data) {
        return SizedBox(
          height: 140,
          child: GridView.builder(
            itemCount: data.length,
            primary: false,
            padding: const EdgeInsets.only(right: 8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 3 : 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 16,
              mainAxisExtent: 60,
            ),
            itemBuilder: (context, index) {
              return CreatorListTile(
                creator: data[index],
              );
            },
          ),
        );
      },
      error: (err, stack) {
        return const Text(
          "Couldn't fetch the data",
          style: TextStyle(color: ColorPalette.dReaderRed),
        );
      },
      loading: () => const SizedBox(
        height: 140,
      ),
    );
  }
}
