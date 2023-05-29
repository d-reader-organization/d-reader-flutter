import 'package:d_reader_flutter/core/models/creator.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/filled_icon.dart';
import 'package:flutter/material.dart';
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
            ? FilledIcon(
                iconData: FontAwesomeIcons.fire,
                url: creator.lynkfire,
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
              )
            : const SizedBox(),
        creator.twitter.isNotEmpty
            ? FilledIcon(
                iconData: FontAwesomeIcons.twitter,
                url: creator.twitter,
              )
            : const SizedBox(),
      ],
    );
  }
}
