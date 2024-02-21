import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/core/models/buy_nft_input.dart';
import 'package:d_reader_flutter/core/models/candy_machine.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/notifiers/listings_notifier.dart';
import 'package:d_reader_flutter/core/providers/auction_house_provider.dart';
import 'package:d_reader_flutter/core/providers/candy_machine_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/ui/utils/candy_machine_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'comic_issue_controller.g.dart';

@riverpod
class ComicIssueController extends _$ComicIssueController {
  late StateController<GlobalState> globalNotifier;
  @override
  FutureOr<void> build() {
    globalNotifier = ref.read(globalStateProvider.notifier);
  }

  _checkIsVerifiedEmail() async {
    final envUser = ref.read(environmentProvider).user;

    if (envUser != null && !envUser.isEmailVerified) {
      final user = await ref.read(myUserProvider.future);
      if (user != null && !user.isEmailVerified) {
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
      final activeGroup = getActiveGroup(candyMachineState.groups);
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

      final mintResult = await ref.read(solanaProvider.notifier).mint(
            candyMachineState.address,
            activeGroup.label,
          );
      if (mintResult is bool && mintResult) {
        ref.invalidate(nftsProvider);
        onSuccessMint();
      } else {
        displaySnackbar(
          text: mintResult is String ? mintResult : 'Something went wrong',
          isError: true,
        );
      }
      ref.read(globalStateProvider.notifier).state.copyWith(isLoading: false);
    } catch (exception) {
      ref.read(globalStateProvider.notifier).state.copyWith(isLoading: false);
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
    final activeWallet = ref.read(environmentProvider).publicKey;
    if (activeWallet == null) {
      throw Exception(
        'There is no wallet selected',
      );
    }
    List<BuyNftInput> selectedNftsInput = ref
        .read(selectedItemsProvider)
        .map(
          (e) => BuyNftInput(
            mintAccount: e.nftAddress,
            price: e.price,
            sellerAddress: e.seller.address,
            buyerAddress: activeWallet.toBase58(),
          ),
        )
        .toList();
    try {
      final isSuccessful = await ref
          .read(solanaProvider.notifier)
          .buyMultiple(selectedNftsInput);
      ref.read(globalStateProvider.notifier).state.copyWith(isLoading: false);
      if (isSuccessful) {
        ref.invalidate(listedItemsProvider);
        ref.invalidate(listingsPaginatedProvider);
        ref.invalidate(userAssetsProvider);
      }
      displaySnackBar(
        text: isSuccessful ? 'Success!' : 'Failed to buy item(s).',
        isSuccess: isSuccessful,
      );
    } catch (exception) {
      ref.read(globalStateProvider.notifier).state.copyWith(isLoading: false);
      onException(exception);
    }
  }
}
