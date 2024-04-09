import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/features/creator/presentation/widgets/cards/creator_card.dart';
import 'package:flutter/material.dart';

class CreatorsGalleryBuilder extends StatelessWidget {
  final List<CreatorModel> creators;
  const CreatorsGalleryBuilder({
    super.key,
    required this.creators,
  });

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.sizeOf(context).width > 600;
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
        childAspectRatio: 156 / 166,
      ),
      itemBuilder: (context, index) {
        return CreatorCard(creator: creators[index]);
      },
    );
  }
}
