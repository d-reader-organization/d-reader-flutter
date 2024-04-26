import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/carrot_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionTimeoutScreen extends StatelessWidget {
  const TransactionTimeoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorPalette.appBackgroundColor,
        body: CarrotErrorWidget(
          mainErrorText: 'Network is congested',
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: MediaQuery.sizeOf(context).height,
          adviceText:
              'Your transaction might have failed.\nPlease check if comic is in your wallet and/or retry the purchase.',
          additionalChild: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextButton(
                backgroundColor: Colors.transparent,
                borderColor: ColorPalette.greyscale50,
                textColor: ColorPalette.greyscale50,
                onPressed: () {
                  context.pop();
                },
                child: Text(
                  'Close',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
