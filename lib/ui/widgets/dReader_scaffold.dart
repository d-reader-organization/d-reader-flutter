import 'package:d_reader_flutter/config/config.dart';
import 'package:flutter/material.dart';

class DReaderScaffold extends StatelessWidget {
  final Widget body;
  const DReaderScaffold({
    Key? key,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: PreferredSize(
        preferredSize: const Size(0, 96),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: AppBar(
            leading: Container(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                Config.logoTextPath,
              ),
            ),
            leadingWidth: 164,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
            actions: const [
              Icon(
                Icons.notifications_none,
              ),
              SizedBox(
                width: 8,
              ),
              Icon(
                Icons.person_outline,
              ),
            ],
          ),
        ),
      ),
      body: body,
    );
  }
}
