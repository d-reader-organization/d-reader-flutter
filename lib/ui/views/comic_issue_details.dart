import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/models/receipt.dart';
import 'package:d_reader_flutter/core/providers/candy_machine_provider.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_address.dart';
import 'package:d_reader_flutter/ui/utils/shorten_nft_name.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/scaffold.dart';
import 'package:d_reader_flutter/ui/widgets/common/dropdown_widget.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:d_reader_flutter/ui/widgets/common/solana_price.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

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
        return ComicIssueDetailsScaffold(
          body: Column(
            children: [
              // const BodyHeader(),
              ListedItems(address: issue.candyMachineAddress ?? ''),
            ],
          ),
          issue: issue,
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

class ListedItems extends ConsumerWidget {
  final String address;
  const ListedItems({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Receipt>> provider =
        ref.watch(receiptsProvider(address));
    return provider.when(
      data: (receipts) {
        if (receipts.isEmpty) {
          return const Text('No items');
        }
        return ListView.separated(
          itemCount: receipts.length,
          padding: const EdgeInsets.only(
            right: 4,
            left: 4,
            top: 12,
            bottom: 4,
          ),
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            return ListingRow(
              receipt: receipts[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              color: ColorPalette.boxBackground400,
            );
          },
        );
      },
      error: (error, stackTrace) {
        print('Listed items error: ${error.toString()}');
        return const Text('Something went wrong');
      },
      loading: () => const SkeletonRow(),
    );
  }
}

class ListingRow extends StatelessWidget {
  final Receipt receipt;
  const ListingRow({
    super.key,
    required this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        maxRadius: 24,
        backgroundImage: CachedNetworkImageProvider(
          receipt.buyer.avatar,
          cacheKey: receipt.buyer.avatar,
        ),
      ),
      title: SizedBox(
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatAddress(receipt.buyer.address),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      shortenNftName(receipt.nft.name),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      timeago.format(
                        DateTime.parse(
                          receipt.timestamp,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.dReaderGreen,
                      ),
                    ),
                  ],
                ),
                SolanaPrice(
                  price: receipt.price,
                ),
              ],
            ),
          ],
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
