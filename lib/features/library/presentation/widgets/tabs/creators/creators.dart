import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/features/creator/presentation/widgets/avatar.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/creators/creators_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/carrot_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreatorsTab extends ConsumerWidget {
  const CreatorsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(followedCreatorsProvider);
    return provider.when(
      data: (data) {
        if (data.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                'Subscibe to your favourite creators',
                style: TextStyle(
                  fontSize: 14,
                  letterSpacing: 0.2,
                  fontWeight: FontWeight.w500,
                  color: ColorPalette.greyscale100,
                ),
              ),
            ],
          );
        }
        return CreatorsListViewBuilder(creators: data);
      },
      loading: () {
        return ListView.separated(
          itemBuilder: (context, index) {
            return const SizedBox();
          },
          separatorBuilder: (context, index) {
            return const SizedBox();
          },
          itemCount: 5,
        );
      },
      error: (e, stk) {
        return const CarrotErrorWiddget(
          mainErrorText: 'We ran into some issues',
          adviceText: 'We are working on a fix. Thanks for your patience!',
        );
      },
      onGoingLoading: (items) {
        return CreatorsListViewBuilder(creators: items);
      },
      onGoingError: (items, e, stk) {
        return CreatorsListViewBuilder(creators: items);
      },
    );
  }
}

class CreatorsListViewBuilder extends ConsumerWidget {
  final List<CreatorModel> creators;
  const CreatorsListViewBuilder({
    super.key,
    required this.creators,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollNotification) {
          double maxScroll = notification.metrics.maxScrollExtent;
          double currentScroll = notification.metrics.pixels;
          double delta = MediaQuery.sizeOf(context).width * 0.1;
          if (maxScroll - currentScroll <= delta) {
            ref.read(followedCreatorsProvider.notifier).fetchNext();
          }
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          if (ref.watch(environmentProvider).user?.id != null) {
            ref.invalidate(followedCreatorsProvider);
          }
        },
        backgroundColor: ColorPalette.dReaderYellow100,
        color: ColorPalette.appBackgroundColor,
        child: ListView.separated(
          itemCount: creators.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) {
            final creator = creators[index];
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: ref.watch(isDeleteInProgress)
                  ? () {
                      ref.read(selectedCreatorSlugs.notifier).update((state) {
                        if (state.contains(creator.slug)) {
                          final items = [...state];
                          items.remove(creator.slug);
                          return items;
                        }
                        return [...state, creator.slug];
                      });
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    ref.watch(isDeleteInProgress)
                        ? SelectableAvatar(creator: creator)
                        : CreatorAvatar(
                            avatar: creator.avatar,
                            height: 48,
                            width: 48,
                            slug: creator.slug,
                          ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          creator.name,
                          style: textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              'Comics: ${creator.stats?.comicsCount}',
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: ColorPalette.greyscale200,
                              ),
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            Text(
                              'Followers: ${creator.stats?.followersCount}',
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: ColorPalette.greyscale200,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              thickness: 1,
              color: ColorPalette.greyscale400,
            );
          },
        ),
      ),
    );
  }
}

class SelectableAvatar extends ConsumerWidget {
  final CreatorModel creator;
  const SelectableAvatar({
    super.key,
    required this.creator,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        CreatorAvatar(
          avatar: creator.avatar,
          height: 48,
          width: 48,
          slug: creator.slug,
        ),
        Positioned.fill(
          left: 24,
          top: 24,
          child: CircleAvatar(
            backgroundColor:
                ref.watch(selectedCreatorSlugs).contains(creator.slug)
                    ? ColorPalette.dReaderGreen
                    : ColorPalette.greyscale100,
            child: SvgPicture.asset(
              'assets/icons/checkmark.svg',
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
