import 'package:d_reader_flutter/ui/widgets/common/cards/collectible_card.dart';
import 'package:flutter/material.dart';

class CreatorCollectiblesListBuilder extends StatelessWidget {
  const CreatorCollectiblesListBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.all(12.0),
          child: CollectibleCard(),
        );
      },
    );
  }
}
