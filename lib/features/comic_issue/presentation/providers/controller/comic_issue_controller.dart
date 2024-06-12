import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/user/presentation/providers/user_providers.dart';
import 'package:d_reader_flutter/features/auction_house/presentation/providers/auction_house_providers.dart';
import 'package:d_reader_flutter/features/auction_house/presentation/providers/listings_provider.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/solana/solana_transaction_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'comic_issue_controller.g.dart';

@riverpod
class ComicIssueController extends _$ComicIssueController {
  @override
  void build() {}

  Future<bool> checkIsVerifiedEmail() async {
    final envUser = ref.read(environmentProvider).user;

    if (envUser != null && !envUser.isEmailVerified) {
      final user = await ref.read(myUserProvider.future);
      if (!user.isEmailVerified) {
        return false;
      }
    }
    return true;
  }

  Future<void> handleBuy({
    required void Function({
      required String text,
      required bool isSuccess,
    }) displaySnackBar,
    required void Function(Object exception) onException,
  }) async {
    try {
      final buyResult = await ref
          .read(solanaTransactionNotifierProvider.notifier)
          .buyMultiple();
      ref.read(globalNotifierProvider.notifier).updateLoading(false);

      buyResult.fold((exception) {
        displaySnackBar(
          isSuccess: false,
          text: exception.message,
        );
      }, (result) async {
        if (result != successResult) {
          return displaySnackBar(isSuccess: false, text: result);
        }
        await Future.delayed(
          const Duration(
            milliseconds: 1000,
          ),
          () {
            displaySnackBar(isSuccess: true, text: 'Success!');
            ref.invalidate(selectedListingsProvider);
            ref.invalidate(selectedListingsPrice);
            ref.invalidate(collectionStatsProvider);
            ref.invalidate(listingsPaginatedProvider);
          },
        );
      });
    } catch (exception) {
      ref.read(globalNotifierProvider.notifier).updateLoading(false);
      onException(exception);
    }
  }
}
