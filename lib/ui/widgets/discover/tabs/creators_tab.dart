import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/core/providers/creator_provider.dart';
import 'package:d_reader_flutter/core/providers/search_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/author_verified.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:d_reader_flutter/ui/widgets/creators/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiscoverCreatorsTab extends ConsumerWidget {
  const DiscoverCreatorsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String search = ref.watch(searchProvider).search;
    AsyncValue<List<CreatorModel>> providerData =
        ref.watch(creatorsProvider('nameSubstring=$search'));
    return providerData.when(
      data: (creators) {
        return creators.isNotEmpty
            ? ListView.separated(
                itemCount: creators.isNotEmpty ? creators.length + 1 : 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const CreatorListHeader();
                  }
                  return CreatorListItem(creator: creators[index - 1]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    color: ColorPalette.boxBackground300,
                  );
                },
              )
            : Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  'No results found',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
      },
      error: (error, stackTrace) {
        return Text('error $error');
      },
      loading: () => ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return const SkeletonRow();
        },
      ),
    );
  }
}

class CreatorListItem extends StatelessWidget {
  final CreatorModel creator;
  const CreatorListItem({
    Key? key,
    required this.creator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        nextScreenPush(context, CreatorDetailsView(slug: creator.slug));
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      leading: CreatorAvatar(
        radius: 32,
        avatar: creator.avatar,
        slug: 'discover-${creator.slug}',
        height: 40,
        width: 40,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: AuthorVerified(
              authorName: creator.name,
              fontSize: 14,
            ),
          ),
          Flexible(
            flex: 1,
            child: SolanaPrice(
              price: creator.stats?.totalVolume,
              mainAxisAlignment: MainAxisAlignment.end,
              textDirection: TextDirection.rtl,
            ),
          ),
          Flexible(
            flex: 1,
            child: Text(
              '${creator.stats?.totalVolume}%',
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorPalette.dReaderGreen,
                  ),
            ),
          ),
          Flexible(
            flex: 1,
            child: SolanaPrice(
              price: creator.stats?.totalVolume,
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}

class CreatorListHeader extends StatelessWidget {
  const CreatorListHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.transparent,
        child: SvgPicture.asset(
          Config.creatorSvg,
          width: 24,
          height: 24,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Row(
              children: [
                Text(
                  'Artists',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                const Icon(
                  Icons.verified,
                  color: Colors.transparent,
                  size: 16,
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Text(
                  'Total\nVol',
                  textAlign: TextAlign.end,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Text(
              '24h %\nVol',
              softWrap: true,
              textAlign: TextAlign.end,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '24h\nVol',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
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
