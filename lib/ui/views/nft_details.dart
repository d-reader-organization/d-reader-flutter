import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_address.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/shorten_nft_name.dart';
import 'package:d_reader_flutter/ui/views/comic_issue_details.dart';
import 'package:d_reader_flutter/ui/views/e_reader.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/nft_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_with_view_more.dart';
import 'package:d_reader_flutter/ui/widgets/nft/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const sectionHeadingStyle = TextStyle(
  color: Color(0xFF777D8C),
  fontSize: 18,
  fontWeight: FontWeight.w700,
);

class NftDetails extends ConsumerWidget {
  final String address;
  const NftDetails({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(nftProvider(address));

    return provider.when(
      data: (nft) {
        nft ??= NftModel.fromJson(
          {
            "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
            "uri":
                "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/CLOSlE94zMJ4CfVMheTw",
            "image":
                "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/rdgflTMG4flbEB4mu48N",
            "name": "Rise of the Gorecats #8",
            "description":
                'Fearless siblings come across a red hawk that has been injured. They work together to help nurse the hawk but...someone.....is knocking on the doors. Who was it? Is it Charlie?',
            "owner": "BnTeboF7M7x78f7mNoG71dgzaCubvGrwQyVHteZoF9rY",
            "royalties": 8,
            "isUsed": false,
            "isSigned": false,
            "comicName": "Gorecats",
            "comicIssueName": "Rise of the Gorecats",
            "comicIssueId": 5,
            "attributes": [
              {"trait": "used", "value": "false"},
              {"trait": "signed", "value": "false"}
            ],
            "isListed": true,
          },
        );

        return Scaffold(
          backgroundColor: ColorPalette.appBackgroundColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                title: Text(
                  shortenNftName(nft.name),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              SliverPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                sliver: SliverToBoxAdapter(
                  child: NfTCard(
                    comicName: nft.comicName,
                    imageUrl: nft.image,
                    issueName: nft.comicIssueName,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Body(nft: nft),
              ),
            ],
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        print('error in nft details ${error.toString()}');
        return const Text('Something went wrong in nft details.');
      },
      loading: () {
        return Scaffold(
          backgroundColor: ColorPalette.appBackgroundColor,
          appBar: AppBar(
            backgroundColor: ColorPalette.appBackgroundColor,
          ),
          body: ListView(
            children: const [
              SkeletonCard(),
              SizedBox(
                height: 8,
              ),
              SkeletonRow(),
              SizedBox(
                height: 8,
              ),
              SkeletonRow(),
              SizedBox(
                height: 8,
              ),
              SkeletonRow(),
            ],
          ),
        );
      },
    );
  }
}

class Body extends StatelessWidget {
  final NftModel nft;
  const Body({
    super.key,
    required this.nft,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const PageScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomTextButton(
                  backgroundColor: ColorPalette.dReaderGreen,
                  size: Size(MediaQuery.of(context).size.width / 2.4, 50),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      8,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        FontAwesomeIcons.glasses,
                        size: 14,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Read',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                  onPressed: () {
                    nextScreenPush(
                      context,
                      EReaderView(
                        issueId: nft.comicIssueId,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Consumer(
                builder: (context, ref, child) {
                  return Expanded(
                    child: CustomTextButton(
                      size: Size(MediaQuery.of(context).size.width / 2.4, 50),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          8,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      isLoading: ref.watch(globalStateProvider).isLoading,
                      child: nft.isListed
                          ? const Text('Delist')
                          : const Text('List'),
                      onPressed: () async {
                        if (nft.isListed) {
                          ref.read(globalStateProvider.notifier).state =
                              const GlobalState(isLoading: true);
                          await ref
                              .read(solanaProvider.notifier)
                              .delist(mint: nft.address);
                          ref.invalidate(nftProvider);
                          ref.read(globalStateProvider.notifier).state =
                              const GlobalState(isLoading: false);
                          return;
                        }
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: NftModalBottomSheet(nft: nft),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Description',
            style: sectionHeadingStyle,
          ),
          const SizedBox(
            height: 4,
          ),
          TextWithViewMore(
            text: nft.description,
          ),
          const SizedBox(
            height: 16,
          ),
          !nft.isUsed || nft.isSigned
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Properties',
                      style: sectionHeadingStyle,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        !nft.isUsed
                            ? Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: ColorPalette.dReaderGreen,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/icons/mint_icon.svg'),
                                    Text(
                                      'Mint',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        nft.isSigned
                            ? Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: ColorPalette.dReaderOrange,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/icons/signed_icon.svg'),
                                    Text(
                                      'Signed',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                )
              : const SizedBox(),
          const Text(
            'Owner',
            style: sectionHeadingStyle,
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Text(
                formatAddress(nft.owner, 12),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                width: 8,
              ),
              GestureDetector(
                child: const Icon(
                  Icons.copy,
                  color: Colors.white,
                  size: 16,
                ),
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: nft.owner,
                    ),
                  ).then(
                    (value) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Owner address copied to clipboard",
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'NFT Address',
            style: sectionHeadingStyle,
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Text(
                formatAddress(nft.address, 12),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(
                width: 8,
              ),
              GestureDetector(
                child: const Icon(
                  Icons.copy,
                  color: Colors.white,
                  size: 16,
                ),
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: nft.address,
                    ),
                  ).then(
                    (value) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "NFT address copied to clipboard",
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          RoundedButton(
            text: 'View Issue Details',
            size: const Size(120, 50),
            borderColor: Colors.white,
            backgroundColor: Colors.transparent,
            textColor: Colors.white,
            onPressed: () {
              nextScreenPush(
                context,
                ComicIssueDetails(
                  id: nft.comicIssueId,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
