import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/creator/presentation/providers/creator_providers.dart';
import 'package:d_reader_flutter/features/home/carousel/presentation/providers/carousel_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/screens/discover.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/comic_issues_list.dart';
import 'package:d_reader_flutter/features/comic/presentation/widgets/comics_list_view.dart';
import 'package:d_reader_flutter/features/home/carousel/presentation/widgets/carousel.dart';
import 'package:d_reader_flutter/features/home/presentation/widgets/section_heading.dart';
import 'package:d_reader_flutter/features/creator/presentation/widgets/creators_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          stretch: true,
          backgroundColor: ColorPalette.appBackgroundColor,
          title: SvgPicture.asset(
            Config.whiteLogoPath,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          onStretchTrigger: () async {
            ref.invalidate(carouselProvider);
            ref.invalidate(comicsProvider);
            ref.invalidate(comicIssuesProvider);
            ref.invalidate(creatorProvider);
          },
          expandedHeight: 344,
          flexibleSpace: const FlexibleSpaceBar(
            stretchModes: [StretchMode.blurBackground],
            collapseMode: CollapseMode.pin,
            background: Carousel(),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 8.0,
                ),
                child: const Column(
                  children: [
                    SizedBox(
                      height: 24,
                    ),
                    SectionHeading(
                      title: 'Popular Comics',
                      initialTab: DiscoverTabViewEnum.comics,
                      filter: FilterId.popular,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    ComicsListView(
                      query: 'skip=0&take=12&filterTag=popular',
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    SectionHeading(
                      title: 'New Episodes',
                      initialTab: DiscoverTabViewEnum.issues,
                      sort: SortByEnum.latest,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    ComicIssuesList(
                      query: 'skip=0&take=12&sortTag=latest',
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    SectionHeading(
                      title: 'Top Creators',
                      initialTab: DiscoverTabViewEnum.creators,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    CreatorsGrid(query: 'skip=0&take=4'),
                    SizedBox(
                      height: 32,
                    ),
                    SectionHeading(
                      title: 'New Comics',
                      initialTab: DiscoverTabViewEnum.comics,
                      sort: SortByEnum.latest,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    ComicsListView(
                      query: 'skip=0&take=12&sortTag=published&sortOrder=desc',
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    SectionHeading(
                      title: 'Free Episodes',
                      initialTab: DiscoverTabViewEnum.issues,
                      filter: FilterId.free,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    ComicIssuesList(
                      query: 'skip=0&take=20&filterTag=free',
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    SectionHeading(
                      title: 'Spicy action',
                      initialTab: DiscoverTabViewEnum.comics,
                      sort: SortByEnum.viewers,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    ComicsListView(
                      query:
                          'skip=0&take=12&sortTag=viewers&sortOrder=desc&genreSlugs[]=action',
                    ),
                    SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
