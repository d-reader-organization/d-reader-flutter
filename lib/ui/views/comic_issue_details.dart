import 'package:d_reader_flutter/ui/widgets/d_reader_scaffold.dart';
import 'package:flutter/material.dart';

class ComicIssueDetails extends StatelessWidget {
  final String slug;
  const ComicIssueDetails({
    Key? key,
    required this.slug,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DReaderScaffold(
      showSearchIcon: true,
      showBottomNavigation: false,
      body: Center(
        child: Text(
          'Comic Issue details $slug',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
