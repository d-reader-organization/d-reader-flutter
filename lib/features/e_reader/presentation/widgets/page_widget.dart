import 'package:d_reader_flutter/features/e_reader/presentation/utils/utils.dart';
import 'package:d_reader_flutter/features/e_reader/presentation/widgets/page_number_widget.dart';
import 'package:d_reader_flutter/shared/domain/models/comic_page.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/common_cached_image.dart';
import 'package:flutter/material.dart';

class PageWidget extends StatelessWidget {
  final int row;
  final bool isPageByPage;
  final PageModel page;
  const PageWidget({
    super.key,
    required this.row,
    required this.page,
    this.isPageByPage = false,
  });

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> valueNotifier = ValueNotifier(row);
    final height = calcPageImageHeight(
      context: context,
      imageHeight: page.height,
      imageWidth: page.width,
    );
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return Stack(
          children: [
            CommonCachedImage(
              height: height,
              width: MediaQuery.sizeOf(context).width,
              fit: BoxFit.cover,
              placeholder: Container(
                height: height,
                width: MediaQuery.sizeOf(context).width,
                color: ColorPalette.greyscale400,
              ),
              imageUrl: page.image,
              onError: () {
                ++valueNotifier.value;
              },
            ),
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 36,
                  right: 16,
                ),
                alignment: Alignment.topRight,
                child: PageNumberWidget(
                  pageNumber: page.pageNumber,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
