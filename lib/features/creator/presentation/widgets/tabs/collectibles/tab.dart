import 'package:flutter/material.dart';

class CreatorCollectiblesTab extends StatelessWidget {
  const CreatorCollectiblesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Nothing to see in here, move along',
      ),
    );
    //  ListView.builder(
    //   itemCount: 1,
    //   itemBuilder: (context, index) {
    //     return const Padding(
    //       padding: EdgeInsets.all(12.0),
    //       child: CollectibleCard(),
    //     );
    //   },
    // );
  }
}
