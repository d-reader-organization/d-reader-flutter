import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/core/providers/creator_provider.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/creators/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreatorsGrid extends ConsumerWidget {
  final String? query;
  const CreatorsGrid({
    Key? key,
    this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isTablet = MediaQuery.sizeOf(context).width > 600;
    AsyncValue<List<CreatorModel>> creators =
        ref.watch(creatorsProvider(query));

    return creators.when(
      data: (data) {
        return GridView.builder(
          itemCount: data.length,
          primary: false,
          padding: const EdgeInsets.only(right: 8),
          shrinkWrap: true,
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
        );
      },
      error: (err, stack) {
        return const Text(
          "Couldn't fetch the data",
          style: TextStyle(color: Colors.red),
        );
      },
      loading: () => SizedBox(
        height: 90,
        child: ListView.builder(
          itemCount: 2,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => const SkeletonCard(),
        ),
      ),
    );
  }
}
