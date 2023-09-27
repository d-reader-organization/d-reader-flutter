import 'package:d_reader_flutter/core/models/collaborator.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/stateless_cover.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/shared/enums.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/rarity.dart';
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
      physics: const PageScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
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
