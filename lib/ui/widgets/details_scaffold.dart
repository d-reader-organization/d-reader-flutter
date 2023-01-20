import 'package:d_reader_flutter/core/models/details_scaffold_model.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/e_reader.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/buy_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/details_scaffold_header.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_app_bar.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DetailsScaffold extends ConsumerWidget {
  final Widget body;
  final bool isComicDetails;
  final DetailsScaffoldModel detailsScaffoldModel;
  const DetailsScaffold({
    Key? key,
    required this.body,
    required this.detailsScaffoldModel,
    this.isComicDetails = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int selectedNfts =
        ref.watch(comicIssueStateNotifier).selectedNftsCount;
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      appBar: const PreferredSize(
        preferredSize: Size(0, 64),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: CustomAppBar(
            showSearchIcon: true,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 0),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          DetailsScaffoldHeader(
            isComicDetails: isComicDetails,
            detailsScaffoldModel: detailsScaffoldModel,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: body,
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      bottomNavigationBar: isComicDetails
          ? null
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BuyButton(
                  size: const Size(180, 50),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'BUY NOW${selectedNfts > 1 ? ' ($selectedNfts)' : ''}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      selectedNfts > 0
                          ? SolanaPrice(
                              price: selectedNfts * 0.965,
                              textColor: Colors.black,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                BuyButton(
                  size: const Size(180, 50),
                  onPressed: () {
                    nextScreenPush(
                        context,
                        EReaderView(
                          pages: detailsScaffoldModel.issuePages ?? [],
                        ));
                  },
                  child: const Text(
                    'PREVIEW',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
