import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/home/episode_circle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComicCard extends StatelessWidget {
  final String title;
  final String authorName;
  final int likesCount;
  final int issuesCount;
  const ComicCard({
    Key? key,
    required this.title,
    required this.authorName,
    required this.likesCount,
    required this.issuesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        height: 255,
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1553095066-5014bc7b7f2d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8d2FsbCUyMGJhY2tncm91bmR8ZW58MHx8MHx8&w=1000&q=80',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            EpisodeCircle(text: '$issuesCount EPs'),
            Positioned(
              left: 12,
              bottom: 40,
              child: SizedBox(
                width: 140,
                child: Text(
                  title,
                  softWrap: true,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 24,
              child: Row(
                children: [
                  Text(
                    authorName,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Icon(
                    Icons.verified,
                    color: dReaderYellow,
                    size: 16,
                  ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 24,
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.heart_fill,
                    color: dReaderRed,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    likesCount.toString(),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFE0E0E0),
                    ),
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
