import 'package:d_reader_flutter/core/models/details_scaffold_model.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/details_scaffold_header.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_app_bar.dart';
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
    );
  }
}
