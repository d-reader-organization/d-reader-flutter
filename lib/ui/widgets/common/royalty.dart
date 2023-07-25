import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoyaltyWidget extends StatelessWidget {
  final String iconPath, text;
  final bool isLarge;
  final Color color;

  const RoyaltyWidget({
    super.key,
    required this.iconPath,
    required this.text,
    required this.color,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: isLarge ? 0 : 1,
      ),
      height: isLarge ? 40 : 24,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isLarge ? 6 : 4),
        border: Border.all(
          color: color,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            height: isLarge ? 14 : 10,
          ),
          const SizedBox(
            width: 4,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: isLarge ? 14 : 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
