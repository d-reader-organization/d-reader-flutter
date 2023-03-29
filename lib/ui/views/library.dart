import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/nft_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/nft_item_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// final walletAssets = List<WalletAsset>.from([
//   {
//     "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
//     "uri":
//         "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/CLOSlE94zMJ4CfVMheTw",
//     "image":
//         "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/rdgflTMG4flbEB4mu48N",
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
//   },
//   {
//     "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
//     "uri":
//         "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/CLOSlE94zMJ4CfVMheTw",
//     "image":
//         "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/rdgflTMG4flbEB4mu48N",
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
//   },
//   {
//     "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
//     "uri":
//         "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/CLOSlE94zMJ4CfVMheTw",
//     "image":
//         "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/rdgflTMG4flbEB4mu48N",
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
//   },
//   {
//     "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
//     "uri":
//         "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/CLOSlE94zMJ4CfVMheTw",
//     "image":
//         "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/rdgflTMG4flbEB4mu48N",
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
//   },
//   {
//     "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
//     "uri":
//         "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/CLOSlE94zMJ4CfVMheTw",
//     "image":
//         "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/rdgflTMG4flbEB4mu48N",
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
    final provider = ref.watch(walletAssetsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(walletAssetsProvider);
      },
      child: provider.when(
        data: (walletAssets) {
          if (walletAssets.isEmpty) {
            return const Center(
              child: Text(
                'Nothing in your library',
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          return GridView.builder(
            itemCount: walletAssets.length,
            primary: false,
            shrinkWrap: true,
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
          print('error in wallet assets ${error.toString()}');
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
