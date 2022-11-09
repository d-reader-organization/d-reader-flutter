import 'package:d_reader_flutter/ui/widgets/comics/comic_card_large.dart';
import 'package:flutter/material.dart';

class CreatorComicsTab extends StatelessWidget {
  const CreatorComicsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(top: 24),
          child: ComicCardLarge(
            index: index,
            isHot: index % 2 == 0,
          ),
        );
      },
    );
  }
}
