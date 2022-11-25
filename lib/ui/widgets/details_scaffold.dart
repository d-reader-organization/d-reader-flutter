import 'package:d_reader_flutter/core/models/details_scaffold_model.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/details_scaffold_header.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_sliver_app_bar.dart';
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
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              const CustomSliverAppBar(),
              DetailsScaffoldHeader(
                isComicDetails: isComicDetails,
                detailsScaffoldModel: detailsScaffoldModel,
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: body,
          ),
        ),
      ),
    );
  }
}
