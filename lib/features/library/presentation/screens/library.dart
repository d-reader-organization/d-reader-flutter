import 'package:d_reader_flutter/features/creator/presentation/providers/creator_providers.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/creators/creators_providers.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/library_providers.dart';
import 'package:d_reader_flutter/features/library/presentation/widgets/tabs/creators/creators.dart';
import 'package:d_reader_flutter/features/library/presentation/widgets/tabs/favorites/favorites.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/shared/widgets/layout/slivers/custom_sliver_tab_bar.dart';
import 'package:d_reader_flutter/features/library/presentation/widgets/tabs/owned/owned.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewLibraryView extends ConsumerStatefulWidget {
  const NewLibraryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => NewLibraryViewState();
}

class NewLibraryViewState extends ConsumerState<NewLibraryView>
    with TickerProviderStateMixin {
  late final TabController _controller =
      TabController(length: 3, vsync: this, initialIndex: 1);

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      ref.read(selectedTabIndex.notifier).update((state) => _controller.index);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(
      registerWalletToSocketEvents,
    );
    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        body: Padding(
          padding: const EdgeInsets.all(4.0),
          child: TabBarView(
            controller: _controller,
            children: const [
              FavoritesTab(),
              OwnedTab(),
              CreatorsTab(),
            ],
          ),
        ),
        floatHeaderSlivers: true,
        physics: const BouncingScrollPhysics(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: ref.watch(selectedTabIndex) == 2 &&
                        ref.watch(isDeleteInProgress)
                    ? const CreatorTabHeader()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Library',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          ref.watch(selectedTabIndex) == 2
                              ? GestureDetector(
                                  onTap: () {
                                    ref
                                        .read(isDeleteInProgress.notifier)
                                        .update((state) => !state);
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/trash.svg',
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
              ),
            ),
            SliverAppBar(
              backgroundColor: ColorPalette.appBackgroundColor,
              titleSpacing: 0,
              floating: true,
              title: CustomSliverTabBar(
                controller: _controller,
                tabs: const [
                  Tab(
                    text: 'Favorites',
                  ),
                  Tab(
                    text: 'Owned',
                  ),
                  Tab(
                    text: 'Creators',
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }
}

class CreatorTabHeader extends ConsumerWidget {
  const CreatorTabHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                ref.read(isDeleteInProgress.notifier).update((state) => !state);
              },
              child: const Icon(
                Icons.close,
                size: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                dividerTheme: const DividerThemeData(
                  color: ColorPalette.appBackgroundColor,
                ),
              ),
              child: PopupMenuButton<String>(
                color: ColorPalette.greyscale400,
                offset: const Offset(
                  0,
                  36,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'all',
                      onTap: () {
                        ref.read(selectedCreatorSlugs.notifier).update(
                            (state) => ref
                                .read(followedCreatorsProvider.notifier)
                                .data
                                .map((item) => item.slug)
                                .toList());
                      },
                      child: Text(
                        'Select all',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.2,
                            ),
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'none',
                      onTap: () {
                        ref
                            .read(selectedCreatorSlugs.notifier)
                            .update((state) => []);
                      },
                      child: Text(
                        'Select none',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.2,
                            ),
                      ),
                    ),
                  ];
                },
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    left: 12,
                    right: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Select items',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.2,
                            ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      SvgPicture.asset(
                        'assets/icons/arrow.svg',
                        height: 12,
                        width: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: ref.watch(selectedCreatorSlugs).isNotEmpty &&
                  !ref.watch(privateLoadingProvider)
              ? () async {
                  await triggerConfirmationDialog(
                    context: context,
                    title: 'Are you sure you want to unfollow creator(s)?',
                    subtitle: '',
                    onTap: () async {
                      await ref.read(
                        unfollowCreatorsProvider(
                          ref.read(
                            selectedCreatorSlugs,
                          ),
                        ).future,
                      );
                    },
                  );
                }
              : null,
          child: Text(
            'Delete',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.2,
                  color: ref.watch(selectedCreatorSlugs).isNotEmpty
                      ? Colors.white
                      : ColorPalette.greyscale200,
                ),
          ),
        ),
      ],
    );
  }
}
