import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/features/creator/presentation/widgets/avatar.dart';
import 'package:flutter/material.dart';

class CreatorListTile extends StatelessWidget {
  final CreatorModel creator;
  const CreatorListTile({
    super.key,
    required this.creator,
  });

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
        style: textTheme.bodySmall,
      ),
    );
  }
}
