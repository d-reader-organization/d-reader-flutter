import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:flutter/material.dart';

class CreatorListTile extends StatelessWidget {
  final String avatar;
  final String name;
  const CreatorListTile({
    Key? key,
    required this.avatar,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreenPush(context, const CreatorDetailsView());
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: dReaderGreen,
              child: Icon(
                //https://stackoverflow.com/questions/65486933/flutter-custom-markers-image-icon-from-url
                Icons.person, // avatar
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.headlineMedium,
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
                  height: 6,
                ),
                Text(
                  '945.38 %',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: dReaderGreen),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
