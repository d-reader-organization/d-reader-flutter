import 'package:d_reader_flutter/ui/widgets/common/icon_with_background.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialRow extends StatelessWidget {
  const SocialRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        IconWithBackground(
          iconData: FontAwesomeIcons.globe,
        ),
        SizedBox(
          width: 6,
        ),
        IconWithBackground(
          iconData: FontAwesomeIcons.instagram,
        ),
        SizedBox(
          width: 6,
        ),
        IconWithBackground(
          iconData: FontAwesomeIcons.solidEnvelope,
        ),
        SizedBox(
          width: 6,
        ),
        IconWithBackground(
          iconData: FontAwesomeIcons.flag,
        ),
      ],
    );
  }
}
