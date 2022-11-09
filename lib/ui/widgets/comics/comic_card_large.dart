import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/description_text.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/episode_circle.dart';
import 'package:d_reader_flutter/ui/widgets/common/figures/genre_rectangle.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/hot_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComicCardLarge extends StatelessWidget {
  final bool isHot;
  final int index;
  const ComicCardLarge({
    Key? key,
    this.isHot = false,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const EpisodeCircle(
                    text: '7EPs - ENDED',
                    color: Color(0xFFC6E7C1),
                    fontSize: 12,
                  ),
                  isHot ? const HotIcon() : const SizedBox(),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'The Barbabyans',
                            style: textTheme.headlineLarge,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Icon(
                            Icons.verified,
                            color: dReaderYellow,
                            size: 20,
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(
                            CupertinoIcons.heart,
                            color: Color(0xFFE0E0E0),
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '19',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFFE0E0E0),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const DescriptionText(
                    text:
                        'Gorecats are an eclectic breed of treacherous little trouble makers, hell bent on using every single one of their glorious nine...',
                  ),
                  Row(
                    children: const [
                      GenreRectangle(title: 'Genre 1'),
                      GenreRectangle(title: 'Genre 2'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
