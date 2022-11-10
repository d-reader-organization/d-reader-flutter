import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/description_text.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:flutter/material.dart';

class ComicIssueCardLarge extends StatelessWidget {
  const ComicIssueCardLarge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 254,
        minHeight: 220,
        maxWidth: double.infinity,
        minWidth: 350,
      ),
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/comic_card.png',
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    16,
                  ),
                  bottomLeft: Radius.circular(
                    16,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: dReaderSome,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EPISODE 1 of 6',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const Text(
                        'The Barbabyans',
                        style: TextStyle(
                          fontSize: 18,
                          color: dReaderYellow,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const Text(
                        'The Barbabyans Ep 1',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const DescriptionText(
                          text:
                              'Gorecats are an eclectic breed of treacherous little trouble makers, hell bent on using every single one of their glorious nine...'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SolanaPrice(
                        price: 0.965,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.remove_red_eye,
                            color: Color(0xFFE0e0e0),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            '349',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: const Color(0xFFE0e0e0)),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
