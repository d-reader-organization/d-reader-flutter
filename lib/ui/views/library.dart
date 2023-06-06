import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/nft_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/nft_item_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// final walletAssets = List<WalletAsset>.from([
//   {
//     "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
//     "uri":
//         "https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80",
//     "image":
//         "https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80",
//     "name": "Rise of the Gorecats #8",
//     "owner": "BnTeboF7M7x78f7mNoG71dgzaCubvGrwQyVHteZoF9rY",
//     "royalties": 4.5,
//     "isUsed": false,
//     "isSigned": false,
//     "comicName": "Gorecats",
//     "comicIssueName": "Rise of the Gorecats",
//     "attributes": [
//       {"trait": "used", "value": "false"},
//       {"trait": "signed", "value": "false"}
//     ]
//   },
//   {
//     "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
//     "uri":
//         "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/CLOSlE94zMJ4CfVMheTw",
//     "image":
//         "https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80",
//     "name": "Rise of the Gorecats #8",
//     "owner": "BnTeboF7M7x78f7mNoG71dgzaCubvGrwQyVHteZoF9rY",
//     "royalties": 4.5,
//     "isUsed": false,
//     "isSigned": false,
//     "comicName": "Gorecats",
//     "comicIssueName": "Rise of the Gorecats",
//     "attributes": [
//       {"trait": "used", "value": "false"},
//       {"trait": "signed", "value": "false"}
//     ]
//   },
//   {
//     "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
//     "uri":
//         "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/CLOSlE94zMJ4CfVMheTw",
//     "image":
//         "https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80",
//     "name": "Rise of the Gorecats #8",
//     "owner": "BnTeboF7M7x78f7mNoG71dgzaCubvGrwQyVHteZoF9rY",
//     "royalties": 4.5,
//     "isUsed": false,
//     "isSigned": false,
//     "comicName": "Gorecats",
//     "comicIssueName": "Rise of the Gorecats",
//     "attributes": [
//       {"trait": "used", "value": "false"},
//       {"trait": "signed", "value": "false"}
//     ]
//   },
//   {
//     "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
//     "uri":
//         "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/CLOSlE94zMJ4CfVMheTw",
//     "image":
//         "https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80",
//     "name": "Rise of the Gorecats #8",
//     "owner": "BnTeboF7M7x78f7mNoG71dgzaCubvGrwQyVHteZoF9rY",
//     "royalties": 4.5,
//     "isUsed": false,
//     "isSigned": false,
//     "comicName": "Gorecats",
//     "comicIssueName": "Rise of the Gorecats",
//     "attributes": [
//       {"trait": "used", "value": "false"},
//       {"trait": "signed", "value": "false"}
//     ]
//   },
//   {
//     "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
//     "uri":
//         "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/CLOSlE94zMJ4CfVMheTw",
//     "image":
//         "https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80",
//     "name": "Rise of the Gorecats #8",
//     "owner": "BnTeboF7M7x78f7mNoG71dgzaCubvGrwQyVHteZoF9rY",
//     "royalties": 8,
//     "isUsed": false,
//     "isSigned": false,
//     "comicName": "Gorecats",
//     "comicIssueName": "Rise of the Gorecats",
//     "attributes": [
//       {"trait": "used", "value": "false"},
//       {"trait": "signed", "value": "false"}
//     ]
//   }
// ].map((item) => WalletAsset.fromJson(item)));

class LibraryView extends ConsumerWidget {
  const LibraryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(
      registerWalletToSocketEvents,
    );
    final provider = ref.watch(walletAssetsProvider);
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(syncWalletProvider.future);
        ref.invalidate(walletAssetsProvider);
      },
      child: provider.when(
        data: (walletAssets) {
          if (walletAssets.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  SvgPicture.asset('assets/icons/bunny_in_the_hole.svg'),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Nothing to see in here!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Buy comic episodes first',
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w500,
                      color: ColorPalette.greyscale100,
                    ),
                  ),
                ],
              ),
            );
          }
          return GridView.builder(
            itemCount: walletAssets.length,
            primary: false,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 12, bottom: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 220,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  nextScreenPush(
                    context,
                    NftDetails(
                      address: walletAssets.elementAt(index).address,
                    ),
                  );
                },
                child: NftItemCard(
                  nftAsset: walletAssets.elementAt(index),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          Sentry.captureException(error, stackTrace: stackTrace);
          return const Text('Something went wrong');
        },
        loading: () {
          return GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 190,
            ),
            children: const [
              SkeletonCard(
                height: 190,
              ),
              SkeletonCard(
                height: 190,
              ),
              SkeletonCard(
                height: 190,
              ),
              SkeletonCard(
                height: 190,
              ),
              SkeletonCard(
                height: 190,
              ),
              SkeletonCard(
                height: 190,
              ),
            ],
          );
        },
      ),
    );
  }
}
