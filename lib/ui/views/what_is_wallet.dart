import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WhatIsWalletView extends StatefulWidget {
  const WhatIsWalletView({super.key});

  @override
  State<WhatIsWalletView> createState() => _WhatIsWalletViewState();
}

class _WhatIsWalletViewState extends State<WhatIsWalletView> {
  String whatIsAWalletText = '';
  String whyDoINeedAWalletText = '';
  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    whatIsAWalletText = await loadWhatIsAWalletAsset();
    whyDoINeedAWalletText = await loadWhyDoINeedAWalletAsset();
    setState(() {});
  }

  Future<String> loadWhatIsAWalletAsset() async {
    return DefaultAssetBundle.of(context)
        .loadString('assets/res/what_is_a_wallet.txt');
  }

  Future<String> loadWhyDoINeedAWalletAsset() async {
    return DefaultAssetBundle.of(context)
        .loadString('assets/res/why_do_i_need_a_wallet.txt');
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
                    context.pop();
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
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Why do I need a wallet?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SelectableText(
                  whyDoINeedAWalletText,
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
