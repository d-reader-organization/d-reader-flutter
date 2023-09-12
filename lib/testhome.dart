import 'package:d_reader_flutter/constants/enums.dart';
import 'package:d_reader_flutter/core/services/local_store.dart';
import 'package:d_reader_flutter/ui/utils/trigger_walkthrough_dialog.dart';
import 'package:flutter/material.dart';

class TestHome extends StatefulWidget {
  const TestHome({super.key});

  @override
  State<TestHome> createState() => _TestHomeState();
}

class _TestHomeState extends State<TestHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final localStore = LocalStore.instance;
      final isAlreadyshown =
          localStore.get(WalkthroughKeys.connectWallet.name) != null;
      if (!isAlreadyshown) {
        triggerWalkthroughDialog(
          context: context,
          onSubmit: () {
            localStore.put(WalkthroughKeys.connectWallet.name, true);
            Navigator.pop(context);
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            triggerWalkthroughDialog(
              context: context,
              onSubmit: () {
                Navigator.pop(context);
              },
            );
          },
          child: const Text(
            'Open',
          ),
        ),
      ),
    );
  }
}
