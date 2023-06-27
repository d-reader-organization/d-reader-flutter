import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/notification_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget {
  final bool showSearchIcon;
  const CustomAppBar({
    Key? key,
    this.showSearchIcon = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(
        padding: const EdgeInsets.all(12),
        child: SvgPicture.asset(
          Config.whiteLogoPath,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
      leadingWidth: 164,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      actions: [
        showSearchIcon
            ? SvgPicture.asset(
                'assets/icons/search.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  ColorPalette.dReaderGrey,
                  BlendMode.srcIn,
                ),
              )
            : const SizedBox(),
        const SizedBox(
          width: 8,
        ),
        const NotificationBadge(),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }
}
