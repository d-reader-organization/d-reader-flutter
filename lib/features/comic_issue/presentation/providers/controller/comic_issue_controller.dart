import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/user/presentation/providers/user_providers.dart';
import 'package:d_reader_flutter/features/auction_house/presentation/providers/auction_house_providers.dart';
import 'package:d_reader_flutter/features/auction_house/presentation/providers/listings_provider.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/providers/digital_asset_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/solana/solana_transaction_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'comic_issue_controller.g.dart';

@riverpod
class ComicIssueController extends _$ComicIssueController {
  @override
  void build() {}

  _checkIsVerifiedEmail() async {
    final envUser = ref.read(environmentProvider).user;

    if (envUser != null && !envUser.isEmailVerified) {
      final user = await ref.read(myUserProvider.future);
      if (!user.isEmailVerified) {
        return false;
      }
    }
    return true;
  }

  Future<void> handleMint({
    required void Function({
      required String text,
      bool isError,
    }) displaySnackbar,
    required void Function() triggerVerificationDialog,
    required void Function() onSuccessMint,
    required void Function(Object exception) onException,
  }) async {
    try {
      CandyMachineModel? candyMachineState =
          ref.read(candyMachineStateProvider);
      if (candyMachineState == null) {
        return displaySnackbar(
            text: 'Failed to find candy machine', isError: false);
      }
      final activeGroup = ref.read(selectedCandyMachineGroup);
      if (activeGroup == null) {
        return displaySnackbar(
          text: 'There is no active mint',
        );
      }
      if (activeGroup.label == dFreeLabel) {
        bool isVerified = await _checkIsVerifiedEmail();
        if (!isVerified) {
          return triggerVerificationDialog();
        }
      }

      final mintResult =
          await ref.read(solanaTransactionNotifierProvider.notifier).mint(
                candyMachineState.address,
                activeGroup.label,
              );
      ref.read(globalNotifierProvider.notifier).updateLoading(false);
      mintResult.fold((exception) {
        displaySnackbar(text: exception.message, isError: true);
      }, (result) {
        if (result != successResult) {
          return displaySnackbar(text: result, isError: true);
        }
        ref.invalidate(digitalAssetsProvider);
        onSuccessMint();
      });
    } catch (exception) {
      ref.read(globalNotifierProvider.notifier).updateLoading(false);
      onException(exception);
    }
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
