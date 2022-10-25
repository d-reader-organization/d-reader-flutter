import 'package:flutter/material.dart';

class RoundedButtonIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final String? tooltip;
  final Icon icon;
  const RoundedButtonIcon({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      child: icon,
    );
  }
}
