import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/buy_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:flutter/material.dart';

String imageUrl =
    'https://d-reader-dev.s3.us-east-1.amazonaws.com/creators/studio-nx/comics/barbabyans/cover.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIA4DWH47RZXHCSECE5%2F20221118%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20221118T154151Z&X-Amz-Expires=3600&X-Amz-Signature=4725f7d03661090726a4efcf82ddba0446b5d546d6e4a8ba32c7d0a4d6d49cd6&X-Amz-SignedHeaders=host&x-id=GetObject';

class ComicCardForSale extends StatelessWidget {
  final ComicIssueModel issue;
  const ComicCardForSale({
    Key? key,
    required this.issue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedImageBgPlaceholder(
      imageUrl: imageUrl,
      width: 176,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '#203',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SolanaPrice(
                price: 0.965,
              ),
              BuyButton(text: 'BUY'),
            ],
          ),
        ],
      ),
    );
  }
}
