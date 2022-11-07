import 'package:d_reader_flutter/ui/views/creators/creator_avatar.dart';
import 'package:d_reader_flutter/ui/widgets/d_reader_scaffold.dart';
import 'package:flutter/material.dart';

class CreatorDetailsView extends StatelessWidget {
  const CreatorDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DReaderScaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                height: 196,
                padding: const EdgeInsets.only(bottom: 8),
                foregroundDecoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0, 1],
                  ),
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://picsum.photos/250?image=15',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CreatorAvatar(),
                ),
              ),
            ],
          ),
        ],
      ),
      showBottomNavigation: false,
    );
  }
}
