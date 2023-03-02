import 'package:flutter/material.dart';

class ResultsWrapper extends StatelessWidget {
  final int resultsCount;
  final Widget body;
  const ResultsWrapper({
    super.key,
    required this.resultsCount,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        body,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 8),
            child: Text(
              resultsCount > 0 ? 'No more results' : 'No results found',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        )
      ],
    );
  }
}
