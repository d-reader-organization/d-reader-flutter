import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/core/providers/creator_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_sliver_tab_persisent_header.dart';
import 'package:d_reader_flutter/ui/widgets/creators/header_sliver_list.dart';
import 'package:d_reader_flutter/ui/widgets/creators/tabs/collectibles/tab.dart';
import 'package:d_reader_flutter/ui/widgets/creators/tabs/comics/tab.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class CreatorDetailsView extends ConsumerWidget {
  final String slug;
  const CreatorDetailsView({
    Key? key,
    required this.slug,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<CreatorModel?> creator = ref.watch(creatorProvider(slug));
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: SafeArea(
          child: creator.when(
        data: (creator) {
          if (creator == null) {
            return const SizedBox();
          }
          return DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  CreatorDetailsHeaderSliverList(creator: creator),
                  StatsDescriptionWidget(creator: creator),
                  const CustomSliverTabPersistentHeader(
                    tabs: [
                      Tab(
                        text: 'Comics',
                      ),
                      Tab(
                        text: 'Collectibles',
                      ),
                    ],
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  CreatorComicsTab(
                    creatorSlug: creator.slug,
                  ),
                  const CreatorCollectiblesTab(),
                ],
              ),
            ),
          );
        },
        error: (err, stack) {
          Sentry.captureException(err, stackTrace: stack);
          return const Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(color: Colors.red),
            ),
          );
        },
        loading: () => const Center(
          child: SizedBox(),
        ),
      )),
    );
  }
}
