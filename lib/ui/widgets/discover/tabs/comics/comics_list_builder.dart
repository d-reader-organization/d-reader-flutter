import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/discover/comic_card.dart';
import 'package:flutter/material.dart';

class ComicListBuilder extends StatelessWidget {
  final List<ComicModel> comics;
  const ComicListBuilder({
    super.key,
    required this.comics,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: comics.length,
      shrinkWrap: true,
      physics: const PageScrollPhysics(),
      itemBuilder: (context, index) {
        return DiscoverComicCard(
          comic: comics[index],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: ColorPalette.greyscale400,
          thickness: 1,
        );
      },
    );
  }
}
