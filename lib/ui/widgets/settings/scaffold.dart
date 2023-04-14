import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsScaffold extends StatelessWidget {
  final Widget body;
  final String appBarTitle;
  const SettingsScaffold({
    super.key,
    required this.body,
    required this.appBarTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: Text(
          appBarTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        leadingWidth: 32,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: body,
      ),
    );
  }
}
