import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ComicIssueCoverScreen extends StatelessWidget {
  final String imageUrl;
  const ComicIssueCoverScreen({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.appBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            context.pop();
          },
          child: const Icon(
            Icons.close,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: ColorPalette.appBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 5,
            child: AspectRatio(
              aspectRatio: comicIssueAspectRatio,
              child: LayoutBuilder(builder: (context, constraints) {
                return CachedImageBgPlaceholder(
                  imageUrl: imageUrl,
                  cacheHeight: constraints.maxHeight.cacheSize(context),
                  cacheWidth: constraints.maxWidth.cacheSize(context),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
