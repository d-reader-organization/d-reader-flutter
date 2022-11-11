import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/description_text.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:flutter/material.dart';

class CollectibleCard extends StatelessWidget {
  const CollectibleCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Container(
          height: 344,
          margin: const EdgeInsets.only(top: 16),
          foregroundDecoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                dReaderDarkGrey,
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [
                0.2,
                0.4,
              ],
            ),
            borderRadius: BorderRadius.circular(
              16,
            ),
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            image: DecorationImage(
              image: AssetImage(
                'assets/images/d_reader_logo.png',
              ),
              fit: BoxFit.cover,
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
                        Text(
                          'EDITION 1/20',
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
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
                              style: textTheme.headlineLarge,
                            ),
                          ],
                        ),
                        const DescriptionText(
                          text:
                              'His people gone. His kingdom a smouldering ruin...\nFollow the perilous adventures of NIKO the mohawked warrior as...',
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
                                const SolanaPrice(
                                  price: 0.965,
                                ),
                              ],
                            ),
                            const RoundedButton(
                              text: 'MAKE OFFER',
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
