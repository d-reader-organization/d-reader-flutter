import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/description_text.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/hot_icon.dart';
import 'package:flutter/material.dart';

String coverUrl =
    'https://d-reader-dev.s3.us-east-1.amazonaws.com/creators/studio-nx/comics/barbabyans/cover.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIA4DWH47RZXHCSECE5%2F20221118%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20221118T084838Z&X-Amz-Expires=3600&X-Amz-Signature=9d10b1fd9d31ac5e62eba9accae29597a58ccef1fc1d075081d1c2878b217e88&X-Amz-SignedHeaders=host&x-id=GetObject';

class DetailsHeaderImage extends StatelessWidget {
  final bool showAwardText;
  const DetailsHeaderImage({
    Key? key,
    required this.showAwardText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Align(
          child: Container(
            height: 364,
            padding: const EdgeInsets.all(16),
            foregroundDecoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.transparent,
                  Colors.black,
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.05, 0.3, 1, 0.7],
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(coverUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(
                16,
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'The Barbayans',
                      style: textTheme.headlineLarge,
                    ),
                    const HotIcon()
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                showAwardText
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                    width: 3,
                                    color: ColorPalette.dReaderYellow100),
                              ),
                            ),
                          ),
                          Text(
                            'by Emmy winning dio Jim Bryson & Adam Jeffcoat',
                            style: textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 12,
                ),
                const DescriptionText(
                  text:
                      '3 magical siblings must prove themselves as the worthy warriors they were destined to become and lead their horde to victory across the land… Or not.',
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
