import 'package:d_reader_flutter/core/models/owned_comic_issue.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/nft_details.dart';
import 'package:d_reader_flutter/ui/widgets/royalties/minted.dart';
import 'package:d_reader_flutter/ui/widgets/royalties/owned_copies.dart';
import 'package:d_reader_flutter/ui/widgets/royalties/signed.dart';
import 'package:flutter/material.dart';

class OwnedIssueCard extends StatelessWidget {
  final OwnedComicIssue issue;

  const OwnedIssueCard({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 126,
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 4,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorPalette.dReaderGreen,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Episode ${issue.number}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ColorPalette.greyscale100,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    issue.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  issue.ownedNft != null
                      ? Row(
                          children: [
                            const MintedRoyalty(),
                            issue.ownedNft!.isSigned
                                ? const SignedRoyalty()
                                : const SizedBox(),
                            OwnedCopies(copiesCount: issue.ownedCopiesCount)
                          ],
                        )
                      : OwnedCopies(copiesCount: issue.ownedCopiesCount),
                  const SizedBox(
                    height: 9,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (issue.ownedNft != null) {
                        nextScreenPush(
                          context,
                          NftDetails(
                            address: issue.ownedNft?.address ?? '',
                          ),
                        );
                      } else {
                        // bottom sheet with nfts
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorPalette.greyscale100,
                        ),
                        borderRadius: BorderRadius.circular(
                          8,
                        ),
                      ),
                      child: const Text(
                        'Info',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
