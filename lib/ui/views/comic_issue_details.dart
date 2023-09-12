import 'package:d_reader_flutter/constants/enums.dart';
import 'package:d_reader_flutter/core/models/comic_issue.dart';
import 'package:d_reader_flutter/core/notifiers/listings_notifier.dart';
import 'package:d_reader_flutter/core/notifiers/receipts_notifier.dart';
import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/trigger_walkthrough_dialog.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/listed_items.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/minted_items.dart';
import 'package:d_reader_flutter/ui/widgets/comic_issues/details/scaffold.dart';
import 'package:d_reader_flutter/ui/widgets/common/dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ComicIssueDetails extends ConsumerStatefulWidget {
  final int id;
  const ComicIssueDetails({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ComicIssueDetailsState();
}

class _ComicIssueDetailsState extends ConsumerState<ComicIssueDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      triggerWalkthroughDialogIfNeeded(
        context: context,
        key: WalkthroughKeys.issueDetails.name,
        title: 'Learn how to buy',
        subtitle: 'You will learn how to buy a comic episode',
        onSubmit: () {
          Navigator.pop(context);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<ComicIssueModel?> provider =
        ref.watch(comicIssueDetailsProvider(
      widget.id,
    ));
    return provider.when(
      data: (issue) {
        if (issue == null) {
          return const SizedBox();
        }
        return ComicIssueDetailsScaffold(
          loadMore: issue.isFree
              ? null
              : issue.candyMachineAddress != null
                  ? ref.read(receiptsAsyncProvider(issue).notifier).fetchNext
                  : ref.read(listingsAsyncProvider(issue).notifier).fetchNext,
          body: CustomScrollView(
            shrinkWrap: true,
            physics: const PageScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 0,
                      ),
                      child: issue.isFree
                          ? const SizedBox()
                          : Center(
                              child: issue.candyMachineAddress != null
                                  ? MintedItems(
                                      issue: issue,
                                    )
                                  : ListedItems(
                                      issue: issue,
                                    ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
          issue: issue,
        );
      },
      error: (err, stack) {
        Sentry.captureException(err, stackTrace: stack);
        return Text(
          'Error: $err',
          style: const TextStyle(color: Colors.red),
        );
      },
      loading: () => const SizedBox(),
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
            prefixIcon: SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: const ColorFilter.mode(
                ColorPalette.dReaderGrey,
                BlendMode.srcIn,
              ),
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
