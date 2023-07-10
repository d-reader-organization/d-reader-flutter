import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/library/cards/owned_issue_card.dart';
import 'package:flutter/material.dart';

class OwnedIssuesItems extends StatelessWidget {
  const OwnedIssuesItems({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'Wretches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          const Divider(
            thickness: 1,
            color: ColorPalette.boxBackground200,
          ),
          const SizedBox(
            height: 4,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const PageScrollPhysics(),
            itemBuilder: (context, index) {
              return const OwnedIssueCard();
            },
            separatorBuilder: (context, index) {
              return const Divider(
                thickness: 1,
                color: ColorPalette.boxBackground200,
              );
            },
            itemCount: 15,
          ),
        ],
      ),
    );
  }
}
