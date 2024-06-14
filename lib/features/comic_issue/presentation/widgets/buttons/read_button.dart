import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _buttonText = 'Read';

class ReadButton extends ConsumerWidget {
  final ComicIssueModel issue;
  const ReadButton({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomTextButton(
      size: const Size(150, 50),
      backgroundColor: Colors.transparent,
      borderColor: ColorPalette.greyscale50,
      textColor: ColorPalette.greyscale50,
      fontSize: 16,
      borderRadius: const BorderRadius.all(
        Radius.circular(
          8,
        ),
      ),
      onPressed: () {
        nextScreenPush(
          context: context,
          path: '${RoutePath.eReader}/${issue.id}',
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            FontAwesomeIcons.glasses,
            size: 14,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            _buttonText,
            style: Theme.of(context).textTheme.titleSmall,
          )
        ],
      ),
    );
  }
}
