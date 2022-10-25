import 'package:d_reader_flutter/core/providers/home_provider.dart';
import 'package:d_reader_flutter/ui/widgets/rounded_button_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int counter = ref.watch(homeProvider).counter;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.appTitle ?? 'dReader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: RoundedButtonIcon(
        onPressed: () {
          ref.read(homeProvider.notifier).incrementCounter();
        },
        tooltip: 'Increment',
        icon: const Icon(Icons.add),
      ),
    );
  }
}
