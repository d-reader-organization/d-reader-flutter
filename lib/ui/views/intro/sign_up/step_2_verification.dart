import 'package:flutter/material.dart';

class SignUpStep2Verification extends StatelessWidget {
  const SignUpStep2Verification({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          flex: 5,
          child: Text('Check your mail.'),
        ),
        Spacer(
          flex: 3,
        ),
        Expanded(
          flex: 1,
          child: Text('Resend'),
        ),
      ],
    );
  }
}
