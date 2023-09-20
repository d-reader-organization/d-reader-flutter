import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/ui/widgets/comics/comic_card.dart';
import 'package:flutter/material.dart';

class ComicGalleryBuilder extends StatelessWidget {
  final List<ComicModel> comics;
  const ComicGalleryBuilder({
    super.key,
    required this.comics,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    bool isTablet = screenWidth > 600;
    return GridView.builder(
      itemCount: comics.length,
      primary: false,
      padding: const EdgeInsets.only(left: 4),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        mainAxisSpacing: 16,
        mainAxisExtent: 226,
      ),
      itemBuilder: (context, index) {
        return ComicCard(
          comic: comics[index],
        );
      },
    );
  }
}
