import 'package:d_reader_flutter/core/models/details_scaffold_model.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/e_reader.dart';
import 'package:d_reader_flutter/ui/widgets/common/app_bar_without_logo.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/buy_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/details_scaffold_header.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_app_bar.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:flutter/material.dart';

class DetailsScaffold extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size(0, 64),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: isComicDetails
              ? const CustomAppBar()
              : AppBarWithoutLogo(
                  title: detailsScaffoldModel.title,
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
                    children: const [
                      Text(
                        'MINT',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      SolanaPrice(
                        price: 0.965,
                        textColor: Colors.black,
                      )
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
