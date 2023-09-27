import 'package:d_reader_flutter/core/models/collaborator.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/stateless_cover.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/shared/enums.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/rarity.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tags_default.dart';
import 'package:flutter/material.dart';

class IssueAbout extends StatelessWidget {
  final ComicIssueModel issue;
  const IssueAbout({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (!issue.isSecondarySaleActive) ...[
          const DecoratedContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Artist mint',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    CircleAvatar(
                      backgroundColor: ColorPalette.greyscale200,
                      radius: 6,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Ended',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ColorPalette.greyscale200,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Free',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          DecoratedContainer(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Allowlist',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        CircleAvatar(
                          backgroundColor: ColorPalette.dReaderYellow100,
                          radius: 6,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'Live',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: ColorPalette.dReaderYellow100,
                          ),
                        ),
                      ],
                    ),
                    SolanaPrice(
                      price: issue.stats?.price?.toDouble(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                LinearProgressIndicator(
                  backgroundColor: ColorPalette.boxBackground300,
                  minHeight: 8,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    ColorPalette.dReaderYellow100,
                  ),
                  value: 0.4,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: 2000',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorPalette.greyscale100,
                      ),
                    ),
                    Text(
                      '461 / 1000 Minted',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorPalette.greyscale100,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          DecoratedContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text(
                      'Public',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    CircleAvatar(
                      backgroundColor: ColorPalette.dReaderYellow300,
                      radius: 6,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Starts in 11h 5m',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ColorPalette.dReaderYellow300,
                      ),
                    ),
                  ],
                ),
                SolanaPrice(
                  price: issue.stats?.price?.toDouble(),
                )
              ],
            ),
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
            color: ColorPalette.boxBackground300,
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
        if (issue.collaborators != null && issue.collaborators!.isNotEmpty) ...[
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
      height: 240,
      child: ListView.builder(
        itemCount: covers.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
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
          );
        },
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorPalette.boxBackground200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}
