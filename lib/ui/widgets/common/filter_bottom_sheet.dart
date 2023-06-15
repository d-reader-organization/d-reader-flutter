import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/sort_menu.dart';
import 'package:d_reader_flutter/ui/widgets/settings/bottom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size(0, 64),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppBar(
            backgroundColor: ColorPalette.appBackgroundColor,
            elevation: 0,
            leading: SvgPicture.asset(
              'assets/icons/filter_2.svg',
              height: 24,
              width: 24,
            ),
            leadingWidth: 24,
            title: const Text('Filter'),
            actions: [
              GestureDetector(
                  onTap: () {
                    return Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const SectionTitle(title: 'Show issues'),
            const SectionDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SectionTitle(title: 'Genres'),
                Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorPalette.dReaderYellow100,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SectionDivider(),
            const SortMenu(),
          ],
        ),
      ),
      bottomNavigationBar: SettingsButtonsBottom(
        isLoading: false,
        cancelText: 'Reset',
        confirmText: 'Filter',
        onCancel: () {},
        onSave: () {},
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(
          height: 16,
        ),
        Divider(
          height: 1,
          thickness: 2,
          color: ColorPalette.boxBackground300,
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
