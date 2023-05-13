import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // Row(
    //   children: [
    //     Stack(
    //       children: [
    //         GestureDetector(
    //           onTap: () {},
    //           child: SvgPicture.asset(
    //             '${Config.settingsAssetsPath}/light/notification.svg',
    //           ),
    //         ),
    //         const Positioned(
    //           right: 0,
    //           top: 0,
    //           child: CircleAvatar(
    //             radius: 6,
    //             backgroundColor: ColorPalette.dReaderYellow100,
    //             child: Text(
    //               '1',
    //               style: TextStyle(
    //                   fontSize: 10, color: ColorPalette.appBackgroundColor),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }
}
