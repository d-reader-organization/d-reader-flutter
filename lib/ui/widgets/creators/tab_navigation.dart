import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/creators/tab_bar.dart';
import 'package:flutter/material.dart';

class CreatorsTabNavigation extends StatelessWidget {
  const CreatorsTabNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: dReaderBlack,
        appBar: CreatorTabBar(
          children: [
            Tab(
              child: Text(
                'Comics',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Issues',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Collectables',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            Center(
              child: Text(
                'Hey ya',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Center(
              child: Text(
                'Hey ya',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Center(
              child: Text(
                'Hey ya',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
