import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SectionHeading extends StatelessWidget {
  final String title;
  const SectionHeading({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          AppLocalizations.of(context)?.seeAll ?? 'See All',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: ColorPalette.dReaderYellow100,
              ),
        ),
      ],
    );
  }
}
