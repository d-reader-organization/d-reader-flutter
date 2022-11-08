import 'package:flutter/material.dart';

class CreatorComicCard extends StatelessWidget {
  final int index;
  const CreatorComicCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 360,
          minHeight: 300,
          maxWidth: 380,
          minWidth: 350,
        ),
        padding: const EdgeInsets.all(16),
        foregroundDecoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Colors.black,
              Colors.transparent,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0, 0.3],
          ),
          borderRadius: BorderRadius.circular(
            16,
          ),
        ),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage(
              'assets/images/comic_card.png',
            ),
          ),
          borderRadius: BorderRadius.circular(
            16,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Text('Hello there'),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text('Hey ya $index'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
