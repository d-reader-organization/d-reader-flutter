import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/features/comic/presentation/widgets/cards/comic_card_large.dart';
import 'package:flutter/material.dart';

class ComicsListBuilder extends StatelessWidget {
  final List<ComicModel> comics;

  const ComicsListBuilder({
    super.key,
    required this.comics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: comics.length,
      shrinkWrap: true,
      physics: const PageScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(top: 16),
          child: ComicCardLarge(
            comic: comics[index],
          ),
        );
      },
    );
  }
}
