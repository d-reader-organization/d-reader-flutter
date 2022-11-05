import 'package:d_reader_flutter/ui/widgets/home/creator_list_tile.dart';
import 'package:flutter/material.dart';

class CreatorsGrid extends StatelessWidget {
  const CreatorsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width > 600;
    return GridView.builder(
      itemCount: 4,
      primary: false,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        mainAxisExtent: 60,
      ),
      itemBuilder: (context, index) {
        return const CreatorListTile();
      },
    );
  }
}
