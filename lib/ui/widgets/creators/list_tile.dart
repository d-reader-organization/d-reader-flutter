import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:flutter/material.dart';

class CreatorListTile extends StatelessWidget {
  final CreatorModel creator;
  const CreatorListTile({
    Key? key,
    required this.creator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      onTap: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.creatorDetails}/${creator.slug}',
        );
      },
      leading: CreatorAvatar(
        avatar: creator.avatar,
        slug: creator.slug,
        radius: 48,
        width: 48,
        height: 48,
      ),
      contentPadding: const EdgeInsets.all(4),
      title: Text(
        creator.name,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}
