import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/home/episode_circle.dart';
import 'package:flutter/material.dart';

class ComicIssueCard extends StatelessWidget {
  final String title;
  final String description;
  final double? price;
  const ComicIssueCard({
    Key? key,
    required this.title,
    required this.description,
    this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 255,
      width: 175,
      decoration: BoxDecoration(
        color: dReaderDarkGrey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 130,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: NetworkImage(
                        'https://images.unsplash.com/photo-1539651044670-315229da9d2f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fHN0cmVldHxlbnwwfHwwfHw%3D&w=1000&q=80'),
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(width: 1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(
                      16,
                    ),
                  ),
                ),
              ),
              const EpisodeCircle(text: 'EP 3/13'),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(right: 4, left: 8, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: dReaderYellow,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      'Studio NX',
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
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Image.asset(
                      Config.solanaLogoPath,
                      width: 14,
                      height: 10,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      price?.toString() ?? 'Free',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
