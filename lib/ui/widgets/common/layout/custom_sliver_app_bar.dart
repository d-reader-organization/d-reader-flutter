import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/logout_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/notification_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSliverAppBar extends StatelessWidget {
  final bool displayLogo;
  const CustomSliverAppBar({
    Key? key,
    this.displayLogo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverAppBar(
        leading: displayLogo
            ? Container(
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  Config.logoTextPath,
                ),
              )
            : null,
        leadingWidth: displayLogo ? 164 : null,
        backgroundColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.transparent,
        actions: const [
          NotificationBadge(),
          SizedBox(
            width: 8,
          ),
          LogoutButton(),
        ],
      ),
    );
  }
}
