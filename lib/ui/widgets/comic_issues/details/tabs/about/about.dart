import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_provider.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/tabs/about/author.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/tabs/about/expandable_container.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/tabs/about/rarities.dart';
import 'package:d_reader_flutter/ui/widgets/genre/genre_tags_default.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IssueAbout extends ConsumerWidget {
  final ComicIssueModel issue;
  const IssueAbout({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final walletAddress = ref.watch(environmentProvider).publicKey?.toBase58();
    return NotificationListener(
      onNotification: (notification) {
        return true;
      },
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          if (issue.activeCandyMachineAddress != null) ...[
            FutureBuilder(
              future: ref.read(
                candyMachineProvider(
                        query:
                            'candyMachineAddress=${issue.activeCandyMachineAddress}${walletAddress != null && walletAddress.isNotEmpty ? '&walletAddress=$walletAddress' : ''}')
                    .future,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasError) {
                  return const SizedBox();
                }

                return Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Minting in progress',
                        style: textTheme.titleMedium,
                      ),
                      Text(
                        'Total: ${snapshot.data?.itemsMinted}/${snapshot.data?.supply}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: ColorPalette.greyscale100,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ...snapshot.data?.groups.map((candyMachineGroup) {
                        return ExpandableContainer(
                          candyMachineGroup: candyMachineGroup,
                          totalSupply: snapshot.data?.supply ?? 0,
                        );
                      }).toList() ??
                      [],
                ]);
              },
            ),
            const SizedBox(
              height: 16,
            ),
          ],
          Text(
            'Genres',
            style: textTheme.titleMedium,
          ),
          GenreTagsDefault(genres: issue.genres),
          const SizedBox(
            height: 16,
          ),
          Text(
            'About',
            style: textTheme.titleMedium,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            issue.description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if ((issue.statelessCovers?.length ?? 0) > 1) ...[
            const SizedBox(
              height: 8,
            ),
            const Divider(
              thickness: 1,
              color: ColorPalette.greyscale400,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Rarities',
              style: textTheme.titleMedium,
            ),
            const SizedBox(
              height: 8,
            ),
            RaritiesWidget(covers: issue.statelessCovers!),
          ],
          if (issue.collaborators != null &&
              issue.collaborators!.isNotEmpty) ...[
            const SizedBox(
              height: 16,
            ),
            Text(
              'Authors list',
              style: textTheme.titleMedium,
            ),
            const SizedBox(
              height: 8,
            ),
            ...issue.collaborators!.map((author) {
              return AuthorWidget(author: author);
            }).toList(),
          ],
        ],
      ),
    );
  }
}
