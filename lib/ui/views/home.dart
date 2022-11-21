import 'package:d_reader_flutter/ui/views/discover.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/comic_issues_grid.dart';
import 'package:d_reader_flutter/ui/widgets/comics/comics_list_view.dart';
import 'package:d_reader_flutter/ui/widgets/common/carousel.dart';
import 'package:d_reader_flutter/ui/widgets/common/search_auto_complete.dart';
import 'package:d_reader_flutter/ui/widgets/common/section_heading.dart';
import 'package:d_reader_flutter/ui/widgets/creators/creators_grid.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: <Widget>[
          const SearchAutoComplete(),
          const SizedBox(
            height: 24,
          ),
          const Carousel(),
          const SizedBox(
            height: 32,
          ),
          SectionHeading(
            title: AppLocalizations.of(context)?.genres ?? 'Genres',
            initialTab: DiscoverTabViewEnum.comics,
          ),
          const SizedBox(
            height: 16,
          ),
          const GenreListView(),
          const SizedBox(
            height: 32,
          ),
          SectionHeading(
            title: AppLocalizations.of(context)?.newComics ?? 'New Comics',
            initialTab: DiscoverTabViewEnum.comics,
          ),
          const SizedBox(
            height: 16,
          ),
          const ComicsListView(),
          const SizedBox(
            height: 32,
          ),
          SectionHeading(
            title:
                AppLocalizations.of(context)?.popularIssues ?? 'Popular Issues',
            initialTab: DiscoverTabViewEnum.issues,
          ),
          const SizedBox(
            height: 16,
          ),
          const ComicIssuesGrid(),
          const SizedBox(
            height: 32,
          ),
          SectionHeading(
            title: AppLocalizations.of(context)?.topCreators ?? 'Top Creators',
            initialTab: DiscoverTabViewEnum.creators,
          ),
          const SizedBox(
            height: 16,
          ),
          const CreatorsGrid(),
          const SizedBox(
            height: 32,
          ),
          SectionHeading(
            title: AppLocalizations.of(context)?.freeIssues ?? 'Free Issues',
            initialTab: DiscoverTabViewEnum.issues,
          ),
          const SizedBox(
            height: 16,
          ),
          const ComicIssuesGrid(),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
