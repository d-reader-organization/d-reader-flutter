import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:flutter/material.dart';

class CreatorsListBuilder extends StatelessWidget {
  final List<CreatorModel> creators;
  const CreatorsListBuilder({
    super.key,
    required this.creators,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: creators.isNotEmpty ? creators.length + 1 : 0,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == 0) {
          return const CreatorListHeader();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: CreatorListItem(creator: creators[index - 1]),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          color: ColorPalette.boxBackground300,
          thickness: 1,
        );
      },
    );
  }
}

class CreatorListItem extends StatelessWidget {
  final CreatorModel creator;
  const CreatorListItem({
    Key? key,
    required this.creator,
  }) : super(key: key);
  final commonTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreenPush(context, CreatorDetailsView(slug: creator.slug));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                CreatorAvatar(
                  avatar: creator.avatar,
                  height: 24,
                  width: 24,
                  slug: creator.slug,
                ),
                const SizedBox(
                  width: 8,
                ),
                AuthorVerified(
                  authorName: creator.name,
                  isVerified: creator.isVerified,
                  fontSize: 16,
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    '--',
                    textAlign: TextAlign.center,
                    style: commonTextStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    '--',
                    textAlign: TextAlign.center,
                    style: commonTextStyle,
                  ),
                ),
                Expanded(
                  child: Text(
                    '--',
                    textAlign: TextAlign.end,
                    style: commonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CreatorListHeader extends StatelessWidget {
  const CreatorListHeader({Key? key}) : super(key: key);
  final commonTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'ARTIST',
              style: commonTextStyle,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    'TOTAL VOL',
                    style: commonTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    '24H % VOL',
                    style: commonTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    '24H VOL',
                    style: commonTextStyle,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
