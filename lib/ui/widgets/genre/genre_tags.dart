import 'package:flutter/material.dart';

class GenreTags extends StatelessWidget {
  const GenreTags({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 20,
          width: 30,
          color: Colors.red,
        ),
        Container(
          height: 20,
          width: 30,
          color: Colors.blue,
        ),
        Container(
          height: 20,
          width: 30,
          color: Colors.green,
        ),
        Container(
          height: 20,
          width: 30,
          color: Colors.blue,
        ),
        Container(
          height: 20,
          width: 30,
          color: Colors.green,
        ),
      ],
    );
  }
}
