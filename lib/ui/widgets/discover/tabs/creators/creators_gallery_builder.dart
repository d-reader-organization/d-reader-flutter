import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/ui/widgets/creators/creator_card.dart';
import 'package:flutter/material.dart';

class CreatorsGalleryBuilder extends StatelessWidget {
  final List<CreatorModel> creators;
  const CreatorsGalleryBuilder({
    super.key,
    required this.creators,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    bool isTablet = screenWidth > 600;
    return GridView.builder(
      itemCount: creators.length,
      primary: false,
      padding: const EdgeInsets.only(
        left: 4,
        top: 8,
      ),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        mainAxisExtent: 166,
      ),
      itemBuilder: (context, index) {
        return CreatorCard(creator: creators[index]);
      },
    );
  }
}
