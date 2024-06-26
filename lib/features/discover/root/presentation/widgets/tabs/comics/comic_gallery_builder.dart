import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/features/comic/presentation/widgets/cards/comic_card.dart';
import 'package:flutter/material.dart';

class ComicGalleryBuilder extends StatelessWidget {
  final List<ComicModel> comics;
  const ComicGalleryBuilder({
    super.key,
    required this.comics,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.sizeOf(context).width > 600;
    return GridView.builder(
      itemCount: comics.length,
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 156 / 235,
      ),
      itemBuilder: (context, index) {
        return ComicCard(
          comic: comics[index],
        );
      },
    );
  }
}
