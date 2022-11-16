import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class DiscoverCreatorsTab extends StatelessWidget {
  const DiscoverCreatorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int itemCount = 10;
    return itemCount > 0
        ? ListView.separated(
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return const CreatorListItem();
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
  }
}

class CreatorListItem extends StatelessWidget {
  const CreatorListItem({Key? key}) : super(key: key);

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
