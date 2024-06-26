import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/features/creator/presentation/utils/utils.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/widgets/texts/author_verified.dart';
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
          color: ColorPalette.greyscale400,
          thickness: 1,
        );
      },
    );
  }
}

class CreatorListItem extends StatelessWidget {
  final CreatorModel creator;
  const CreatorListItem({
    super.key,
    required this.creator,
  });
  final commonTextStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.creatorDetails}/${creator.slug}',
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                renderAvatar(context: context, creator: creator),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: AuthorVerified(
                    authorName: creator.name,
                    isVerified: creator.isVerified,
                    fontSize: 16,
                  ),
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
  const CreatorListHeader({super.key});
  final commonTextStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: ColorPalette.greyscale200,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8.0,
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
