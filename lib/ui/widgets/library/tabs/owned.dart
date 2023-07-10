import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/library/owned_nft_item.dart';
import 'package:flutter/material.dart';

class OwnedListView extends StatelessWidget {
  const OwnedListView({super.key});

  helper(int index) {
    switch (index) {
      case 0:
        return 'A';
      case 1:
        return 'B';
      case 2:
        return 'C';
      case 3:
        return 'D';
      case 4:
        return 'E';
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollNotification) {
          double maxScroll = notification.metrics.maxScrollExtent;
          double currentScroll = notification.metrics.pixels;
          double delta = MediaQuery.sizeOf(context).width * 0.1;
          if (maxScroll - currentScroll <= delta) {
            // call fetchNext
          }
        }
        return true;
      },
      child: ListView.separated(
        itemCount: 5,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(
              top: 8,
              bottom: 8,
            ),
            child: OwnedNftItems(
              letter: helper(index),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            thickness: 1,
            color: ColorPalette.boxBackground300,
          );
        },
      ),
    );
  }
}
