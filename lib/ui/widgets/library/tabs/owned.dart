import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/notifiers/owned_comics_notifier.dart';
import 'package:d_reader_flutter/core/providers/library/selected_owned_comic_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/library_utils.dart';
import 'package:d_reader_flutter/ui/widgets/library/owned_comic_items.dart';
import 'package:d_reader_flutter/ui/widgets/library/owned_issues_items.dart';
import 'package:d_reader_flutter/ui/widgets/library/tabs/owned_nfts_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class OwnedListView extends ConsumerWidget {
  const OwnedListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(
      ownedComicsAsyncProvider(
        ref.watch(environmentProvider).user?.id ?? 0,
      ),
    );

    return ref.watch(selectedOwnedComicProvider) != null
        ? ref.watch(selectedIssueInfoProvider) != null
            ? OwnedNftsItems(issue: ref.read(selectedIssueInfoProvider)!)
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
              Map<String, int> sortedLetters = sortAndGetLetterOccurences(data);
              return NotificationListener(
                onNotification: (notification) {
                  if (notification is ScrollNotification) {
                    double maxScroll = notification.metrics.maxScrollExtent;
                    double currentScroll = notification.metrics.pixels;
                    double delta = MediaQuery.sizeOf(context).width * 0.1;
                    if (maxScroll - currentScroll <= delta) {
                      ref
                          .read(ownedComicsAsyncProvider(
                            ref.read(environmentProvider).user?.id ?? 0,
                          ).notifier)
                          .fetchNext();
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
                      ref.invalidate(ownedComicsAsyncProvider);
                    }
                  },
                  backgroundColor: ColorPalette.dReaderYellow100,
                  color: ColorPalette.appBackgroundColor,
                  child: ListView.separated(
                    itemCount: sortedLetters.keys.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final (startAt, endAtLimit) =
                          getSublistBorders(sortedLetters, index);
                      return Container(
                        margin: const EdgeInsets.only(
                          top: 8,
                          bottom: 8,
                        ),
                        child: OwnedComicItems(
                          letter: sortedLetters.keys.elementAt(index),
                          comics: data.sublist(
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
            },
            error: (error, stackTrace) {
              Sentry.captureException(error, stackTrace: stackTrace);
              return const Center(
                child: Text('Nothing to see in here.'),
              );
            },
            loading: () {
              return const LoadingOwnedComicItems();
            },
          );
  }
}
