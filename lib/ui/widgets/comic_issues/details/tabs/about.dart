import 'package:d_reader_flutter/core/models/candy_machine_group.dart';
import 'package:d_reader_flutter/core/models/collaborator.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/stateless_cover.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/candy_machine_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_issue/provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/shared/enums.dart';
import 'package:d_reader_flutter/ui/utils/format_date.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/rarity.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tags_default.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IssueAbout extends ConsumerWidget {
  final ComicIssueModel issue;
  const IssueAbout({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAddress = ref.watch(environmentProvider).publicKey?.toBase58();
    return NotificationListener(
      onNotification: (notification) {
        return true;
      },
      child: ListView(
        shrinkWrap: true,
        physics: const PageScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          if (issue.activeCandyMachineAddress != null) ...[
            FutureBuilder(
              future: ref.read(
                candyMachineProvider(
                        query:
                            'candyMachineAddress=${issue.activeCandyMachineAddress}${walletAddress != null && walletAddress.isNotEmpty ? '&walletAddress=$walletAddress' : ''}')
                    .future,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError) {
                  return const SizedBox();
                }

                return Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Minting in progress',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Total: ${snapshot.data?.itemsMinted}/${snapshot.data?.supply}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorPalette.greyscale100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ...snapshot.data?.groups.map((candyMachineGroup) {
                        return ExpandableDecoratedContainer(
                          candyMachineGroup: candyMachineGroup,
                          totalSupply: snapshot.data?.supply ?? 0,
                        );
                      }).toList() ??
                      [],
                ]);
              },
            ),
            const SizedBox(
              height: 16,
            ),
          ],
          const Text(
            'Genres',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          GenreTagsDefault(genres: issue.genres),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'About',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            issue.description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if ((issue.statelessCovers?.length ?? 0) > 1) ...[
            const SizedBox(
              height: 8,
            ),
            const Divider(
              thickness: 1,
              color: ColorPalette.greyscale400,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              'Rarities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            RaritiesWidget(covers: issue.statelessCovers!),
          ],
          if (issue.collaborators != null &&
              issue.collaborators!.isNotEmpty) ...[
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Authors list',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ...issue.collaborators!.map((author) {
              return AuthorWidget(author: author);
            }).toList(),
          ],
        ],
      ),
    );
  }
}

class AuthorWidget extends StatelessWidget {
  final Collaborator author;
  const AuthorWidget({
    super.key,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${author.role} - ${author.name}',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class RaritiesWidget extends StatelessWidget {
  final List<StatelessCover> covers;
  const RaritiesWidget({
    super.key,
    required this.covers,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 237,
      child: ListView.builder(
        itemCount: covers.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                CachedImageBgPlaceholder(
                  imageUrl: covers[index].image,
                  width: 137,
                  height: 197,
                ),
                const SizedBox(
                  height: 16,
                ),
                RarityWidget(
                  rarity: covers[index].rarity?.rarityEnum ?? NftRarity.none,
                  iconPath: 'assets/icons/rarity.svg',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ExpandableDecoratedContainer extends ConsumerWidget {
  final CandyMachineGroupModel candyMachineGroup;
  final int totalSupply;
  const ExpandableDecoratedContainer({
    super.key,
    required this.candyMachineGroup,
    required this.totalSupply,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFutureMint = candyMachineGroup.startDate != null &&
        candyMachineGroup.startDate!.isAfter(DateTime.now());
    return GestureDetector(
      onTap: () {
        ref.read(expandedCandyMachineGroup.notifier).update((state) =>
            state != candyMachineGroup.label ? candyMachineGroup.label : '');
      },
      child: AnimatedContainer(
        height: ref.watch(expandedCandyMachineGroup) == candyMachineGroup.label
            ? 108
            : 46,
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        child: DecoratedContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        candyMachineGroup.displayLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      candyMachineGroup.isActive
                          ? const CircleAvatar(
                              backgroundColor: ColorPalette.dReaderYellow100,
                              radius: 6,
                            )
                          : const SizedBox(),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        candyMachineGroup.isActive
                            ? 'Live'
                            : isFutureMint
                                ? 'Starts in ${formatDateInRelative(candyMachineGroup.startDate)}'
                                : 'Ended',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: candyMachineGroup.isActive
                              ? ColorPalette.dReaderYellow100
                              : isFutureMint
                                  ? ColorPalette.dReaderYellow300
                                  : ColorPalette.greyscale200,
                        ),
                      ),
                    ],
                  ),
                  SolanaPrice(
                    price: formatLamportPrice(
                      candyMachineGroup.mintPrice.round(),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  LinearProgressIndicator(
                    backgroundColor: ColorPalette.greyscale400,
                    minHeight: 8,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      candyMachineGroup.isActive
                          ? ColorPalette.dReaderYellow100
                          : ColorPalette.greyscale200,
                    ),
                    value: candyMachineGroup.itemsMinted /
                        candyMachineGroup.supply,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'You minted: ${candyMachineGroup.wallet.itemsMinted}/${candyMachineGroup.wallet.supply ?? '∞'}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorPalette.greyscale100,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${candyMachineGroup.itemsMinted} / ${candyMachineGroup.supply}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: ColorPalette.greyscale100,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DecoratedContainer extends StatelessWidget {
  final Widget child;
  const DecoratedContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorPalette.greyscale500,
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}
