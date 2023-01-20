import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/details_scaffold_model.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/dropdown_widget.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:d_reader_flutter/ui/widgets/details_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComicIssueDetails extends ConsumerWidget {
  final int id;
  const ComicIssueDetails({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ComicIssueModel?> provider =
        ref.watch(comicIssueDetailsProvider(id));
    return provider.when(
      data: (issue) {
        if (issue == null) {
          return const SizedBox();
        }
        return DetailsScaffold(
          isComicDetails: false,
          detailsScaffoldModel: DetailsScaffoldModel(
              slug: issue.slug,
              imageUrl: issue.cover,
              description: issue.description,
              title: issue.comic?.name ?? '',
              subtitle: issue.title,
              avatarUrl: issue.creator.avatar,
              creatorSlug: issue.creator.slug,
              creatorName: issue.creator.name,
              issuePages: issue.pages,
              favouriteStats: FavouriteStats(
                count: 5,
                isFavourite: true,
              ),
              episodeNumber: issue.number,
              generalStats: GeneralStats(
                  totalIssuesCount: issue.stats!.totalIssuesCount,
                  totalVolume: issue.stats!.totalVolume,
                  floorPrice: issue.stats!.floorPrice,
                  totalSupply: issue.supply,
                  totalListedCount: issue.stats!.totalListedCount),
              releaseDate: issue.releaseDate),
          body: Column(
            children: [
              const BodyHeader(),
              ListView.separated(
                itemCount: 5,
                padding: const EdgeInsets.only(
                    right: 4, left: 4, top: 12, bottom: 4),
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return const ListingRow();
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    color: ColorPalette.boxBackground400,
                  );
                },
              )
            ],
          ),
        );
      },
      error: (err, stack) {
        print(stack);
        return Text(
          'Error: $err',
          style: const TextStyle(color: Colors.red),
        );
      },
      loading: () => const SizedBox(),
    );
  }
}

class ListingRow extends ConsumerStatefulWidget {
  const ListingRow({
    super.key,
  });

  @override
  ConsumerState<ListingRow> createState() => _ListingRowState();
}

class _ListingRowState extends ConsumerState<ListingRow> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isSelected
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: ColorPalette.dReaderYellow100,
                ),
                top: BorderSide(
                  width: 1,
                  color: ColorPalette.dReaderYellow100,
                ),
              ),
            )
          : const BoxDecoration(),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 4),
        tileColor: isSelected ? ColorPalette.boxBackground300 : null,
        leading: const CircleAvatar(
          backgroundColor: ColorPalette.dReaderGreen,
          maxRadius: 24,
        ),
        onTap: () {
          setState(() {
            isSelected = !isSelected;
            ref.read(comicIssueStateNotifier.notifier).update(isSelected);
          });
        },
        title: SizedBox(
          height: 48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '7aLBCr...S7eKPD',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '#9692',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Rare',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: ColorPalette.dReaderGreen,
                    ),
                  ),
                  SolanaPrice(
                    price: 0.965,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BodyHeader extends StatelessWidget {
  const BodyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> choices = [
      'All',
      'Mint unsigned',
      'Mint signed',
      'Used unsigned',
      'Used signed'
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextField(
          cursorColor: Colors.white,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(4),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.solid,
                color: ColorPalette.boxBackground400,
              ),
              borderRadius: BorderRadius.circular(
                6.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 1,
                style: BorderStyle.solid,
                color: ColorPalette.boxBackground400,
              ),
              borderRadius: BorderRadius.circular(
                6.0,
              ),
            ),
            labelText: '#1203..',
            labelStyle: const TextStyle(
                fontSize: 12, color: ColorPalette.boxBackground400),
            constraints: const BoxConstraints(
                maxHeight: 37, minHeight: 37, maxWidth: 150, minWidth: 150),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ),
        const DropdownWidget(),
        Theme(
          data: Theme.of(context)
              .copyWith(cardColor: ColorPalette.boxBackground400),
          child: PopupMenuButton<String>(
            icon: const Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
            onSelected: (index) {},
            itemBuilder: (BuildContext context) {
              return choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ),
      ],
    );
  }
}
