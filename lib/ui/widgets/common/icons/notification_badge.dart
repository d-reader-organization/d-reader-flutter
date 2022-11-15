import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  const NotificationBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.notifications_none,
              ),
            ),
            const Positioned(
              right: 0,
              top: 0,
              child: CircleAvatar(
                radius: 6,
                backgroundColor: dReaderYellow,
                child: Text(
                  '1',
                  style: TextStyle(fontSize: 10, color: dReaderBlack),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
