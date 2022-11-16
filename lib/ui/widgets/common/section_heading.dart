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
    TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.headlineMedium,
        ),
        Text(
          AppLocalizations.of(context)?.seeAll ?? 'See All',
          style: textTheme.titleSmall?.copyWith(
            color: ColorPalette.dReaderYellow100,
          ),
        ),
      ],
    );
  }
}
