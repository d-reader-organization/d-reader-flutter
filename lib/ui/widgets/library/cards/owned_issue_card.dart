import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/models/owned_comic_issue.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/library/selected_owned_comic_provider.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/e_reader.dart';
import 'package:d_reader_flutter/ui/views/nft_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/royalty.dart';
import 'package:d_reader_flutter/ui/widgets/library/modals/owned_nfts_bottom_sheet.dart';
import 'package:d_reader_flutter/ui/widgets/royalties/owned_copies.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OwnedIssueCard extends ConsumerWidget {
  final OwnedComicIssue issue;

  const OwnedIssueCard({
    super.key,
    required this.issue,
  });

  openModalBottomSheet(BuildContext context, List<NftModel> ownedNfts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: ownedNfts.length > 1 ? 0.65 : 0.5,
          minChildSize: ownedNfts.length > 1 ? 0.65 : 0.5,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return OwnedNftsBottomSheet(
              ownedNfts: ownedNfts,
              ownedIssue: issue,
            );
          },
        );
      },
    );
  }

  fetchOwnedNfts(WidgetRef ref, String comicIssueId) async {
    final globalNotifier = ref.read(globalStateProvider.notifier);
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    final ownedNfts = await ref.read(nftsProvider(
            'comicIssueId=$comicIssueId&owner=${ref.read(environmentProvider).publicKey?.toBase58()}')
        .future);
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: false,
      ),
    );
    return ownedNfts;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: ref.watch(globalStateProvider).isLoading
          ? null
          : () async {
              final List<NftModel> ownedNfts =
                  await fetchOwnedNfts(ref, '${issue.id}');

              final isAtLeastOneUsed = ownedNfts.any((nft) => nft.isUsed);

              if (context.mounted) {
                if (isAtLeastOneUsed) {
                  return nextScreenPush(
                      context, EReaderView(issueId: issue.id));
                }
                openModalBottomSheet(context, ownedNfts);
              }
            },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 130,
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 4,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: CachedImageBgPlaceholder(
                imageUrl: issue.cover,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                      Text(
                        issue.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  issue.ownedNft != null
                      ? Row(
                          children: [
                            const RoyaltyWidget(
                              iconPath: 'assets/icons/mint_icon.svg',
                              text: 'Mint',
                              color: ColorPalette.dReaderGreen,
                            ),
                            issue.ownedNft!.isSigned
                                ? const RoyaltyWidget(
                                    iconPath: 'assets/icons/signed_icon.svg',
                                    text: 'Signed',
                                    color: ColorPalette.dReaderOrange,
                                  )
                                : const SizedBox(),
                            OwnedCopies(copiesCount: issue.ownedCopiesCount)
                          ],
                        )
                      : OwnedCopies(copiesCount: issue.ownedCopiesCount),
                  const SizedBox(),
                  GestureDetector(
                    onTap: ref.watch(globalStateProvider).isLoading
                        ? null
                        : () async {
                            final List<NftModel> ownedNfts =
                                await fetchOwnedNfts(ref, '${issue.id}');

                            final int usedNftIndex = ownedNfts
                                .indexWhere((element) => element.isUsed);

                            if (context.mounted &&
                                (usedNftIndex > -1 || ownedNfts.length == 1)) {
                              final properIndex =
                                  usedNftIndex > -1 ? usedNftIndex : 0;
                              return nextScreenPush(
                                context,
                                NftDetails(
                                  address:
                                      ownedNfts.elementAt(properIndex).address,
                                ),
                              );
                            }
                            final ComicIssueModel? comicIssue = await ref.read(
                              comicIssueDetailsProvider(issue.id).future,
                            );
                            ref
                                .read(selectedIssueInfoProvider.notifier)
                                .update((state) => comicIssue);
                          },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
