import 'package:d_reader_flutter/ui/widgets/d_reader_scaffold.dart';
import 'package:d_reader_flutter/ui/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DReaderScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            SearchBar(),
          ],
        ),
      ),
    );
  }
}
