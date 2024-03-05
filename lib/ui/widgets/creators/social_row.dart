import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/launch_external_url.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/filled_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialRow extends StatelessWidget {
  final CreatorModel creator;
  const SocialRow({
    Key? key,
    required this.creator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        creator.lynkfire.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  openUrl(creator.lynkfire);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    color: ColorPalette.greyscale400,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/lynkfire.svg',
                    height: 20,
                    width: 24,
                  ),
                ),
              )
            : const SizedBox(),
        creator.website.isNotEmpty
            ? FilledIcon(
                iconData: FontAwesomeIcons.globe,
                url: creator.website,
              )
            : const SizedBox(),
        creator.instagram.isNotEmpty
            ? FilledIcon(
                iconData: FontAwesomeIcons.instagram,
                url: creator.instagram,
                shouldOpenApplication: true,
              )
            : const SizedBox(),
        creator.twitter.isNotEmpty
            ? FilledIcon(
                iconData: FontAwesomeIcons.twitter,
                url: creator.twitter,
                shouldOpenApplication: true,
              )
            : const SizedBox(),
      ],
    );
  }
}
