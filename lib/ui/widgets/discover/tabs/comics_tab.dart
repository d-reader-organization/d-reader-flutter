import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/discover/card.dart';
import 'package:flutter/material.dart';

class DiscoverComicsTab extends StatelessWidget {
  const DiscoverComicsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int itemCount = 10;
    return itemCount > 0
        ? ListView.separated(
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return const DiscoverCard(
                episodeText: '3 EPs',
              );
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
