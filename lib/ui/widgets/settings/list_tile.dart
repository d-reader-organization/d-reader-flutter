import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsCommonListTile extends StatelessWidget {
  final String title;
  final String leadingPath;
  final Function()? onTap;
  final Color? overrideColor;
  final Widget? overrideTrailing, overrideLeading;
  const SettingsCommonListTile({
    super.key,
    required this.title,
    required this.leadingPath,
    this.onTap,
    this.overrideColor,
    this.overrideTrailing,
    this.overrideLeading,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = overrideColor ??
        (onTap == null ? ColorPalette.boxBackground400 : Colors.white);
    return ListTile(
      onTap: onTap,
      textColor: overrideColor ?? color,
      leading: overrideLeading ??
          SvgPicture.asset(
            leadingPath,
            colorFilter: ColorFilter.mode(
              color,
              BlendMode.srcIn,
            ),
          ),
      contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      minLeadingWidth: 20,
      trailing: overrideTrailing ??
          SvgPicture.asset(
            'assets/icons/arrow_right.svg',
            colorFilter: ColorFilter.mode(
              color,
              BlendMode.srcIn,
            ),
          ),
    );
  }
}
