import 'package:d_reader_flutter/core/models/collaborator.dart';
import 'package:flutter/material.dart';

class AuthorWidget extends StatelessWidget {
  final Collaborator author;
  const AuthorWidget({
    super.key,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${author.role} - ${author.name}',
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
