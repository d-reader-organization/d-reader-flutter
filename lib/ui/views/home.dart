import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/creator/presentations/providers/creator_providers.dart';
import 'package:d_reader_flutter/features/home/carousel/presentations/providers/carousel_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/ui/views/discover.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_issues_list.dart';
import 'package:d_reader_flutter/ui/widgets/comics/comics_list_view.dart';
import 'package:d_reader_flutter/ui/widgets/common/carousel.dart';
import 'package:d_reader_flutter/ui/widgets/common/section_heading.dart';
import 'package:d_reader_flutter/ui/widgets/creators/creators_grid.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(carouselProvider);
          ref.invalidate(comicsProvider);
          ref.invalidate(comicIssuesProvider);
          ref.invalidate(creatorProvider);
        },
        backgroundColor: ColorPalette.dReaderYellow100,
        color: ColorPalette.appBackgroundColor,
        child: const SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Carousel(),
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  top: 8.0,
                ),
                child: Column(
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
      ),
    );
  }
}
