import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/local_wallet/local_wallet_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/tabs/about/author.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/tabs/about/mint_info_container.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/widgets/tabs/about/rarities.dart';
import 'package:d_reader_flutter/features/discover/genre/presentation/widgets/genre_tags_default.dart';
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
    final walletAddress =
        ref.watch(environmentProvider).publicKey?.toBase58() ??
            ref.read(localWalletNotifierProvider).value?.address;
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  final currentCandyMachine =
                      ref.read(candyMachineStateProvider);
                  if (currentCandyMachine != null &&
                      currentCandyMachine.address ==
                          issue.activeCandyMachineAddress) {
                    return MintInfoContainer(
                      candyMachineGroups: currentCandyMachine.groups,
                      totalSupply: currentCandyMachine.supply,
                    );
                  }
                  return const SizedBox();
                }
                if (snapshot.hasError) {
                  return const SizedBox();
                }
                return MintInfoContainer(
                  candyMachineGroups: snapshot.data?.groups ?? [],
                  totalSupply: snapshot.data?.supply ?? 0,
                );
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
            }),
          ],
        ],
      ),
    );
  }
}
