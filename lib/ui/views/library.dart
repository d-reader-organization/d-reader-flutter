import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/nft_details.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/nft_item_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/cards/skeleton_card.dart';
import 'package:d_reader_flutter/ui/widgets/common/layout/custom_sliver_tab_persisent_header.dart';
import 'package:d_reader_flutter/ui/widgets/library/tabs/owned.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
      if (_controller.indexIsChanging && _controller.previousIndex == 1) {
        _controller.index = 1;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: NestedScrollView(
          body: Padding(
            padding: const EdgeInsets.all(4.0),
            child: TabBarView(
              controller: _controller,
              children: const [
                Text('Coming soon'),
                OwnedListView(),
                Text('Coming soon'),
              ],
            ),
          ),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                leading: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Library',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            return;
                          },
                          child: SvgPicture.asset(
                            'assets/icons/search.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ]),
                ),
                leadingWidth: double.infinity,
                backgroundColor: ColorPalette.appBackgroundColor,
              ),
              CustomSliverTabPersistentHeader(
                controller: _controller,
                tabs: const [
                  Tab(
                    child: Text(
                      'Favorites',
                      style: TextStyle(
                        color: ColorPalette.boxBackground400,
                      ),
                    ),
                  ),
                  Tab(
                    text: 'Owned',
                  ),
                  Tab(
                    child: Text(
                      'Creators',
                      style: TextStyle(
                        color: ColorPalette.boxBackground400,
                      ),
                    ),
                  ),
                ],
              ),
            ];
          },
        ));
  }
}

class LibraryView extends ConsumerWidget {
  const LibraryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(
      registerWalletToSocketEvents,
    );
    final provider = ref.watch(walletAssetsProvider);
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(syncWalletProvider.future);
        ref.invalidate(walletAssetsProvider);
      },
      child: provider.when(
        data: (walletAssets) {
          if (walletAssets.isEmpty) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  SvgPicture.asset('assets/icons/bunny_in_the_hole.svg'),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Nothing to see in here!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Buy comic episodes first',
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 0.2,
                      fontWeight: FontWeight.w500,
                      color: ColorPalette.greyscale100,
                    ),
                  ),
                ],
              ),
            );
          }
          return GridView.builder(
            itemCount: walletAssets.length,
            primary: false,
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 12, bottom: 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 220,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  nextScreenPush(
                    context,
                    NftDetails(
                      address: walletAssets.elementAt(index).address,
                    ),
                  );
                },
                child: NftItemCard(
                  nftAsset: walletAssets.elementAt(index),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          Sentry.captureException(error, stackTrace: stackTrace);
          return const Text('Something went wrong');
        },
        loading: () {
          return GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 190,
            ),
            children: const [
              SkeletonCard(
                height: 190,
              ),
              SkeletonCard(
                height: 190,
              ),
              SkeletonCard(
                height: 190,
              ),
              SkeletonCard(
                height: 190,
              ),
              SkeletonCard(
                height: 190,
              ),
              SkeletonCard(
                height: 190,
              ),
            ],
          );
        },
      ),
    );
  }
}
