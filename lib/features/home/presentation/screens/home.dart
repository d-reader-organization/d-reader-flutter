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
          centerTitle: false,
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
          expandedHeight: 384,
          flexibleSpace: const FlexibleSpaceBar(
            stretchModes: [StretchMode.blurBackground],
            collapseMode: CollapseMode.pin,
            background: Carousel(),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return const Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  top: 32.0,
                  bottom: 32,
                ),
                child: Wrap(
                  runSpacing: 32,
                  children: [
                    _SectionItem(
                      title: 'Popular Comics',
                      initialTab: DiscoverTabViewEnum.comics,
                      filter: FilterId.popular,
                      child: ComicsListView(
                        query: 'skip=0&take=12&filterTag=popular',
                      ),
                    ),
                    _SectionItem(
                      title: 'New Episodes',
                      initialTab: DiscoverTabViewEnum.issues,
                      sort: SortByEnum.latest,
                      child: ComicIssuesList(
                        query: 'skip=0&take=12&sortTag=latest',
                      ),
                    ),
                    _SectionItem(
                      title: 'Top Creators',
                      initialTab: DiscoverTabViewEnum.creators,
                      child: CreatorsGrid(
                        query: 'skip=0&take=4&sortTag=followers&sortOrder=desc',
                      ),
                    ),
                    _SectionItem(
                      title: 'New Comics',
                      initialTab: DiscoverTabViewEnum.comics,
                      sort: SortByEnum.latest,
                      child: ComicsListView(
                        query:
                            'skip=0&take=12&sortTag=published&sortOrder=desc',
                      ),
                    ),
                    _SectionItem(
                      title: 'Free Episodes',
                      initialTab: DiscoverTabViewEnum.issues,
                      filter: FilterId.free,
                      child: ComicIssuesList(
                        query: 'skip=0&take=20&filterTag=free',
                      ),
                    ),
                    _SectionItem(
                      title: 'Spicy action',
                      initialTab: DiscoverTabViewEnum.comics,
                      sort: SortByEnum.viewers,
                      child: ComicsListView(
                        query:
                            'skip=0&take=12&sortTag=viewers&sortOrder=desc&genreSlugs[]=action',
                      ),
                    ),
                  ],
                ),
              );
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }
}

class _SectionItem extends StatelessWidget {
  final FilterId? filter;
  final DiscoverTabViewEnum? initialTab;
  final SortByEnum? sort;
  final String title;
  final Widget child;

  const _SectionItem({
    required this.child,
    this.filter,
    this.initialTab,
    this.sort,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeading(
          title: title,
          filter: filter,
          initialTab: initialTab,
          sort: sort,
        ),
        const SizedBox(
          height: 24,
        ),
        child,
      ],
    );
  }
}
