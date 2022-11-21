import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/core/providers/creator_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_sliver_app_bar.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_sliver_tab_persisent_header.dart';
import 'package:d_reader_flutter/ui/widgets/creators/header_sliver_list.dart';
import 'package:d_reader_flutter/ui/widgets/creators/tabs/collectibles_tab.dart';
import 'package:d_reader_flutter/ui/widgets/creators/tabs/comics_tab.dart';
import 'package:d_reader_flutter/ui/widgets/creators/tabs/issues_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatorDetailsView extends ConsumerWidget {
  final String slug;
  const CreatorDetailsView({
    Key? key,
    required this.slug,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<CreatorModel> creator = ref.watch(creatorProvider(slug));
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: SafeArea(
          child: creator.when(
        data: (data) {
          return Stack(
            children: [
              DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      const CustomSliverAppBar(),
                      CreatorDetailsHeaderSliverList(creator: data),
                      const CustomSliverTabPersistentHeader(
                        tabs: [
                          Tab(
                            child: Text(
                              'Comics',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Tab(
                            child: Text('Issues',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Tab(
                            child: Text('Collectables',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ];
                  },
                  body: const TabBarView(
                    children: [
                      CreatorComicsTab(),
                      CreatorIssuesTab(),
                      CollectiblesTab(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        error: (err, stack) {
          print(stack);
          return Text(
            'Error: $err',
            style: const TextStyle(color: Colors.red),
          );
        },
        loading: () => const Center(
          child: SizedBox(
            height: 400,
            child: SkeletonCard(),
          ),
        ),
      )),
    );
  }
}
