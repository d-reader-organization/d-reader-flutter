import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:flutter/material.dart';

class CreatorListTile extends StatelessWidget {
  const CreatorListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 30,
            child: Icon(Icons.person),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Astronaut',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  const Icon(
                    Icons.verified,
                    color: dReaderYellow,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                '945.38 %',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: dReaderGreen),
              )
            ],
          ),
        ],
      ),
    );
  }
}
