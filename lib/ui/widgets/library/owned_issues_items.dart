import 'package:d_reader_flutter/core/models/comic.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/notifiers/owned_issues_notifier.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/widgets/library/cards/owned_issue_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class OwnedIssuesItems extends ConsumerWidget {
  final ComicModel comic;
  const OwnedIssuesItems({
    super.key,
    required this.comic,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(
      ownedIssuesAsyncProvider(
        ref.watch(environmentProvider).publicKey?.toBase58() ?? '',
      ),
    );

    return provider.when(
      data: (data) {
        if (data.isEmpty) {
          return const Text('Something went wrong.');
        }
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
                  Text(
                    comic.title,
                    style: const TextStyle(
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
                  return OwnedIssueCard(issue: data[index]);
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
      },
      error: (Object error, StackTrace stackTrace) {
        Sentry.captureException(error, stackTrace: stackTrace);
        return const Center(
          child: Text('Nothing to see in here.'),
        );
      },
      loading: () {
        return const LoadingOwnedIssuesView();
      },
    );
  }
}

class LoadingOwnedIssuesView extends StatelessWidget {
  const LoadingOwnedIssuesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
