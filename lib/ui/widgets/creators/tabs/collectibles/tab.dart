import 'package:flutter/material.dart';

class CreatorCollectiblesTab extends StatelessWidget {
  const CreatorCollectiblesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Nothing to see in here, move along',
      ),
    );
    //  ListView.builder(
    //   itemCount: 1,
    //   shrinkWrap: true,
    //   itemBuilder: (context, index) {
    //     return const Padding(
    //       padding: EdgeInsets.all(12.0),
    //       child: CollectibleCard(),
    //     );
    //   },
    // );
  }
}
