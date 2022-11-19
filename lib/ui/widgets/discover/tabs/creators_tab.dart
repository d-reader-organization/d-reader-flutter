import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/core/providers/creator_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:d_reader_flutter/ui/widgets/creators/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DiscoverCreatorsTab extends ConsumerWidget {
  const DiscoverCreatorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<CreatorModel>> providerData = ref.watch(creatorsProvider);
    return providerData.when(
      data: (creators) {
        return creators.isNotEmpty
            ? ListView.separated(
                itemCount: creators.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return CreatorListTile(creator: creators[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    color: ColorPalette.boxBackground300,
                  );
                },
              )
            : Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  'No results found',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
      },
      error: (error, stackTrace) {
        return Text('error $error');
      },
      loading: () => ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return const SkeletonRow();
        },
      ),
    );
  }
}

class CreatorListItem extends StatelessWidget {
  final CreatorModel creator;
  const CreatorListItem({
    Key? key,
    required this.creator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      leading: const CircleAvatar(
        backgroundColor: ColorPalette.dReaderGrey,
        radius: 32,
      ),
      title: Text(
        'NAME',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
