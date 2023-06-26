import 'package:d_reader_flutter/core/providers/discover/filter_provider.dart';
import 'package:d_reader_flutter/ui/views/discover.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_issues_grid.dart';
import 'package:d_reader_flutter/ui/widgets/comics/comics_list_view.dart';
import 'package:d_reader_flutter/ui/widgets/common/carousel.dart';
import 'package:d_reader_flutter/ui/widgets/common/minting_progress.dart';
import 'package:d_reader_flutter/ui/widgets/common/section_heading.dart';
// import 'package:d_reader_flutter/ui/widgets/common/search_auto_complete.dart';
import 'package:d_reader_flutter/ui/widgets/creators/creators_grid.dart';
// import 'package:d_reader_flutter/ui/widgets/genre/genre_list_view.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MintingProgressWidget(),
            // const SearchAutoComplete(),
            // const SizedBox(
            //   height: 24,
            // ),
            const Carousel(),
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12,
                top: 8.0,
              ),
              child: Column(
                children: const [
                  // const SizedBox(
                  //   height: 32,
                  // ),
                  // SectionHeading(
                  //   title: AppLocalizations.of(context)?.genres ?? 'Genres',
                  // ),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  // const GenreListView(),
                  SizedBox(
                    height: 24,
                  ),
                  SectionHeading(
                    title: 'Popular Comics',
                    initialTab: DiscoverTabViewEnum.comics,
                    filter: FilterId.popular,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ComicsListView(
                    query: 'skip=0&take=4',
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
                    height: 16,
                  ),
                  ComicIssuesGrid(
                    query: 'skip=0&take=4',
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  SectionHeading(
                    title: 'Top Creators',
                    initialTab: DiscoverTabViewEnum.creators,
                  ),
                  SizedBox(
                    height: 16,
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
                    height: 16,
                  ),
                  ComicsListView(
                    query: 'skip=4&take=4',
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
                    height: 16,
                  ),
                  ComicIssuesGrid(
                    query: 'skip=4&take=4',
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
    );
  }
}
