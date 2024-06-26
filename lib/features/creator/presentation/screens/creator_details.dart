import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/features/creator/presentation/providers/creator_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/render_carrot_error.dart';
import 'package:d_reader_flutter/shared/widgets/layout/slivers/custom_sliver_tab_persisent_header.dart';
import 'package:d_reader_flutter/features/creator/presentation/widgets/header_sliver_list.dart';
import 'package:d_reader_flutter/features/creator/presentation/widgets/tabs/collectibles/tab.dart';
import 'package:d_reader_flutter/features/creator/presentation/widgets/tabs/comics/tab.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreatorDetailsView extends ConsumerWidget {
  final String slug;

  const CreatorDetailsView({
    super.key,
    required this.slug,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<CreatorModel?> creator = ref.watch(creatorProvider(slug));
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      extendBodyBehindAppBar: true,
      body: creator.when(
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
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 8,
                    ),
                  ),
                  const CustomSliverTabPersistentHeader(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
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
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: TabBarView(
                  children: [
                    CreatorComicsTab(
                      creatorSlug: creator.slug,
                    ),
                    const CreatorCollectiblesTab(),
                  ],
                ),
              ),
            ),
          );
        },
        error: (err, stack) {
          return renderCarrotErrorWidget(ref);
        },
        loading: () => const SizedBox(),
      ),
    );
  }
}
