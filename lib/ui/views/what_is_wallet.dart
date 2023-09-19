import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class WhatIsWalletView extends StatefulWidget {
  const WhatIsWalletView({super.key});

  @override
  State<WhatIsWalletView> createState() => _WhatIsWalletViewState();
}

class _WhatIsWalletViewState extends State<WhatIsWalletView> {
  String whatIsAWalletText = '';

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    whatIsAWalletText = await loadAsset();
  }

  Future<String> loadAsset() async {
    return await DefaultAssetBundle.of(context)
        .loadString('assets/res/what_is_a_wallet.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.appBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'What is a wallet?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SelectableText(
                  whatIsAWalletText,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
