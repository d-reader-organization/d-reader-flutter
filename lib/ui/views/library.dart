import 'package:d_reader_flutter/core/models/nft.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/nft_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/nft_item_card.dart';
import 'package:flutter/material.dart';

final walletAssets = List<WalletAsset>.from([
  {
    "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
    "uri":
        "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/CLOSlE94zMJ4CfVMheTw",
    "image":
        "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/rdgflTMG4flbEB4mu48N",
    "name": "Rise of the Gorecats #8",
    "owner": "BnTeboF7M7x78f7mNoG71dgzaCubvGrwQyVHteZoF9rY",
    "royalties": 8,
    "isMintCondition": false,
    "isSigned": false,
    "comicName": "Gorecats",
    "comicIssueName": "Rise of the Gorecats",
    "attributes": [
      {"trait": "used", "value": "false"},
      {"trait": "signed", "value": "false"}
    ]
  },
  {
    "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
    "uri":
        "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/CLOSlE94zMJ4CfVMheTw",
    "image":
        "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/rdgflTMG4flbEB4mu48N",
    "name": "Rise of the Gorecats #8",
    "owner": "BnTeboF7M7x78f7mNoG71dgzaCubvGrwQyVHteZoF9rY",
    "royalties": 8,
    "isMintCondition": false,
    "isSigned": false,
    "comicName": "Gorecats",
    "comicIssueName": "Rise of the Gorecats",
    "attributes": [
      {"trait": "used", "value": "false"},
      {"trait": "signed", "value": "false"}
    ]
  },
  {
    "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
    "uri":
        "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/CLOSlE94zMJ4CfVMheTw",
    "image":
        "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/rdgflTMG4flbEB4mu48N",
    "name": "Rise of the Gorecats #8",
    "owner": "BnTeboF7M7x78f7mNoG71dgzaCubvGrwQyVHteZoF9rY",
    "royalties": 8,
    "isMintCondition": false,
    "isSigned": false,
    "comicName": "Gorecats",
    "comicIssueName": "Rise of the Gorecats",
    "attributes": [
      {"trait": "used", "value": "false"},
      {"trait": "signed", "value": "false"}
    ]
  },
  {
    "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
    "uri":
        "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/CLOSlE94zMJ4CfVMheTw",
    "image":
        "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/rdgflTMG4flbEB4mu48N",
    "name": "Rise of the Gorecats #8",
    "owner": "BnTeboF7M7x78f7mNoG71dgzaCubvGrwQyVHteZoF9rY",
    "royalties": 8,
    "isMintCondition": false,
    "isSigned": false,
    "comicName": "Gorecats",
    "comicIssueName": "Rise of the Gorecats",
    "attributes": [
      {"trait": "used", "value": "false"},
      {"trait": "signed", "value": "false"}
    ]
  },
  {
    "address": "CXS1HQHrgnu6Sjd7HDw7HN5E2vPU8VbhUNyhWfDxYJXe",
    "uri":
        "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/CLOSlE94zMJ4CfVMheTw",
    "image":
        "https://s3.us-east-1.amazonaws.com/d-reader-dev-metadata/rdgflTMG4flbEB4mu48N",
    "name": "Rise of the Gorecats #8",
    "owner": "BnTeboF7M7x78f7mNoG71dgzaCubvGrwQyVHteZoF9rY",
    "royalties": 8,
    "isMintCondition": false,
    "isSigned": false,
    "comicName": "Gorecats",
    "comicIssueName": "Rise of the Gorecats",
    "attributes": [
      {"trait": "used", "value": "false"},
      {"trait": "signed", "value": "false"}
    ]
  }
].map((item) => WalletAsset.fromJson(item)));

class LibraryView extends StatelessWidget {
  const LibraryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: walletAssets.length,
      primary: false,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 190,
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
  }
}
