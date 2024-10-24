import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/shared/widgets/image_widgets/cached_image_bg_placeholder.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/price_widget.dart';
import 'package:flutter/material.dart';

const String imageUrl =
    'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png';

class CollectibleCard extends StatelessWidget {
  const CollectibleCard({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        CachedImageBgPlaceholder(
          imageUrl: imageUrl,
          height: 344,
          foregroundDecoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                ColorPalette.greyscale500,
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0, 0.3],
            ),
            borderRadius: BorderRadius.circular(
              16,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 344,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: ColorPalette.appBackgroundColor,
                          ),
                          child: Text(
                            'EDITION 1/20',
                            style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Caught in a Mugwhump\'s HypnoRay',
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const Text(
                          'His people gone. His kingdom a smouldering ruin...\nFollow the perilous adventures of NIKO the mohawked warrior as...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: .2,
                          ),
                          textAlign: TextAlign.start,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Last sold at',
                                  style: textTheme.labelMedium
                                      ?.copyWith(fontSize: 11),
                                ),
                                const PriceWidget(
                                  price: 0.965,
                                ),
                              ],
                            ),
                            CustomTextButton(
                              onPressed: () {},
                              child: const Text('MAKE OFFER'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
