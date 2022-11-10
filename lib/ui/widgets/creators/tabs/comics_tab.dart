import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/ui/widgets/comics/comic_card_large.dart';
import 'package:flutter/material.dart';

class CreatorComicsTab extends StatelessWidget {
  final List<ComicModel> comics;
  const CreatorComicsTab({
    super.key,
    required this.comics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comics.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(top: 24),
          child: ComicCardLarge(
            comic: comics[index],
          ),
        );
      },
    );
  }
}
