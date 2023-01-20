import 'package:d_reader_flutter/core/models/page_model.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/cover_cached_image.dart';
import 'package:flutter/material.dart';

class EReaderView extends StatelessWidget {
  final List<PageModel> pages;
  const EReaderView({super.key, required this.pages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: ListView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return CommonCachedImage(imageUrl: pages[index].image);
        },
      ),
    );
  }
}
