import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:flutter/material.dart';

class DigitalAssetCard extends StatelessWidget {
  final String imageUrl;
  final String comicName;
  final String issueName;
  const DigitalAssetCard({
    super.key,
    required this.imageUrl,
    required this.comicName,
    required this.issueName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreenPush(
          context: context,
          path: RoutePath.comicIssueCover,
          extra: imageUrl,
        );
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 232,
          maxHeight: 338,
        ),
        child: AspectRatio(
          aspectRatio: comicIssueAspectRatio,
          child: CachedImageBgPlaceholder(
            imageUrl: imageUrl,
            bgImageFit: BoxFit.scaleDown,
            placeholder: const SizedBox(),
          ),
        ),
      ),
    );
  }
}
