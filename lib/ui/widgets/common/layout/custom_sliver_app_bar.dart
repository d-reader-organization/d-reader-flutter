import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/user_icon_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/icons/notification_badge.dart';
import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverAppBar(
        leading: Container(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            Config.logoTextPath,
          ),
        ),
        leadingWidth: 164,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: const [
          Icon(
            Icons.search,
          ),
          SizedBox(
            width: 8,
          ),
          NotificationBadge(),
          SizedBox(
            width: 8,
          ),
          UserIconButton(),
        ],
      ),
    );
  }
}
