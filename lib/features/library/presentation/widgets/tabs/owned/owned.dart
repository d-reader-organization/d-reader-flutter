import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/owned/owned_providers.dart';
import 'package:d_reader_flutter/features/library/presentation/utils/utils.dart';
import 'package:d_reader_flutter/features/user/domain/providers/user_provider.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/features/library/presentation/widgets/common/library_comic_items.dart';
import 'package:d_reader_flutter/features/library/presentation/widgets/tabs/owned/owned_issues_items.dart';
import 'package:d_reader_flutter/features/library/presentation/widgets/tabs/owned/owned_digital_assets_items.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/carrot_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OwnedTab extends ConsumerWidget {
  const OwnedTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(ownedComicsProvider);
    return ref.watch(selectedOwnedComicProvider) != null
        ? ref.watch(selectedIssueInfoProvider) != null
            ? OwnedDigitalAssetsItems(
                issue: ref.read(selectedIssueInfoProvider)!)
            : OwnedIssuesItems(comic: ref.read(selectedOwnedComicProvider)!)
        : provider.when(
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
                      'Buy comic episodes first',
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
              return OwnedComicsListBuilder(comics: data);
            },
            error: (error, stackTrace) {
              return const CarrotErrorWidget(
                mainErrorText: 'We ran into some issues',
                adviceText:
                    'We are working on a fix. Thanks for your patience!',
              );
            },
            loading: () {
              return const LoadingOwnedComicItems();
            },
            onGoingLoading: (items) {
              return OwnedComicsListBuilder(comics: items);
            },
            onGoingError: (items, e, stk) {
              return OwnedComicsListBuilder(comics: items);
            },
          );
  }
}

class OwnedComicsListBuilder extends ConsumerWidget {
  final List<ComicModel> comics;
  const OwnedComicsListBuilder({
    super.key,
    required this.comics,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, int> sortedLetters = sortAndGetLetterOccurences(comics);
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollNotification) {
          double maxScroll = notification.metrics.maxScrollExtent;
          double currentScroll = notification.metrics.pixels;
          double delta = MediaQuery.sizeOf(context).width * 0.1;
          if (maxScroll - currentScroll <= delta) {
            ref.read(ownedComicsProvider.notifier).fetchNext();
          }
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          if (ref.watch(environmentProvider).user?.id != null) {
            await ref
                .read(userRepositoryProvider)
                .syncWallets(ref.watch(environmentProvider).user!.id);
            ref.invalidate(ownedComicsProvider);
          }
        },
        backgroundColor: ColorPalette.dReaderYellow100,
        color: ColorPalette.appBackgroundColor,
        child: ListView.separated(
          itemCount: sortedLetters.keys.length,
          padding: const EdgeInsets.symmetric(vertical: 8),
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final (startAt, endAtLimit) =
                getSublistBorders(sortedLetters, index);
            return Container(
              margin: const EdgeInsets.only(
                top: 8,
                bottom: 8,
              ),
              child: LibraryComicItems(
                letter: sortedLetters.keys.elementAt(index),
                comics: comics.sublist(
                  startAt,
                  endAtLimit,
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
