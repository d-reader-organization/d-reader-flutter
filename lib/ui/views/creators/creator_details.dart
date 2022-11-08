import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_avatar.dart';
import 'package:d_reader_flutter/ui/widgets/creators/creator_tabs.dart';
import 'package:d_reader_flutter/ui/widgets/creators/image_gradient_background.dart';
import 'package:d_reader_flutter/ui/widgets/creators/social_row.dart';
import 'package:d_reader_flutter/ui/widgets/creators/stats_box_row.dart';
import 'package:d_reader_flutter/ui/widgets/d_reader_scaffold.dart';
import 'package:flutter/material.dart';

class CreatorDetailsView extends StatelessWidget {
  const CreatorDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DReaderScaffold(
      body: ListView(
        children: [
          Stack(
            children: const [
              ImageGradientBackground(),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CreatorAvatar(),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Studio NX',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.verified,
                color: dReaderYellow,
                size: 16,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    width: 1,
                    color: dReaderSome,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star_outline,
                      size: 20,
                      color: dReaderLightGrey,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      'Follow',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: dReaderLightGrey,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          9,
                        ),
                        color: dReaderSome,
                      ),
                      child: Text(
                        '124',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: dReaderLightGrey,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    )
                  ],
                ),
              ),
              const SocialRow(),
            ],
          ),
          const SizedBox(
            height: 32,
          ),
          const StatsBoxRow(),
          const SizedBox(
            height: 24,
          ),
          Text(
            'StudioNX is an Emmy award winning visual development house that creates character driven IP for feature film, TV & games.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 24,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const CreatorsTab(),
          ),
        ],
      ),
      showBottomNavigation: false,
    );
  }
}
