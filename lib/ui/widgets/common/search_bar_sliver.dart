import 'package:d_reader_flutter/core/providers/search_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/shared/styles.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/filter_icon.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchBarSliver extends ConsumerWidget {
  final TabController controller;
  const SearchBarSliver({
    Key? key,
    required this.controller,
  }) : super(key: key);
  void _submitHandler(WidgetRef ref) {
    String search = ref.read(searchProvider).searchController.text.trim();
    ref.read(searchProvider.notifier).updateSearchValue(search);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      sliver: SliverAppBar(
        backgroundColor: ColorPalette.appBackgroundColor,
        toolbarHeight: 72,
        pinned: true,
        leadingWidth: double.infinity,
        leading: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: ref.read(searchProvider).searchController,
              textInputAction: TextInputAction.search,
              cursorColor: Colors.white,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
              ),
              decoration: searchInputDecoration(
                hintText: 'Search comics, issues & genres',
                prefixIcon: IconButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _submitHandler(ref);
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/search.svg',
                    colorFilter: const ColorFilter.mode(
                      ColorPalette.dReaderGrey,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                suffixIcon: const FilterIcon(),
              ),
              onFieldSubmitted: (value) {
                _submitHandler(ref);
              },
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 48),
          child: Container(
            padding: const EdgeInsets.only(
              left: 4,
              right: 4,
              bottom: 4,
            ),
            margin: const EdgeInsets.only(top: 8, bottom: 2),
            child: Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: ColorPalette.greyscale400,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
                TabBar(
                  controller: controller,
                  dividerColor: ColorPalette.dReaderGrey,
                  onTap: (int index) {
                    ref.read(searchProvider.notifier).updateSearchValue('');
                    ref.read(searchProvider).searchController.clear();
                  },
                  indicatorWeight: 4,
                  indicatorColor: ColorPalette.dReaderYellow100,
                  labelColor: ColorPalette.dReaderYellow100,
                  unselectedLabelColor: ColorPalette.dReaderGrey,
                  tabs: const [
                    Tab(
                      text: 'Comics',
                    ),
                    Tab(
                      text: 'Issues',
                    ),
                    Tab(
                      text: 'Creators',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
