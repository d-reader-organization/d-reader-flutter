import 'package:d_reader_flutter/features/creator/domain/models/creator.dart';
import 'package:d_reader_flutter/shared/domain/models/pagination/pagination_state.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/carrot_error_widget.dart';
import 'package:d_reader_flutter/shared/widgets/unsorted/skeleton_row.dart';
import 'package:d_reader_flutter/features/discover/root/presentation/widgets/tabs/creators/creators_list_builder.dart';
import 'package:flutter/material.dart';

class CreatorsList extends StatelessWidget {
  final PaginationState<CreatorModel> provider;
  const CreatorsList({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return provider.when(
      data: (creators) {
        return CreatorsListBuilder(creators: creators);
      },
      error: (err, stack) {
        return const CarrotErrorWiddget(
          mainErrorText: 'We ran into some issues',
          adviceText: 'We are working on a fix. Thanks for your patience!',
        );
      },
      loading: () => ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return const SizedBox(height: 56, child: SkeletonRow());
        },
      ),
      onGoingError: (List<CreatorModel> items, Object? e, StackTrace? stk) {
        return CreatorsListBuilder(
          creators: items,
        );
      },
      onGoingLoading: (List<CreatorModel> items) {
        return CreatorsListBuilder(
          creators: items,
        );
      },
    );
  }
}
