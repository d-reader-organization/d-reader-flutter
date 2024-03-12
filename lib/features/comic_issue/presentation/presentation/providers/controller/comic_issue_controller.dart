import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/user/presentations/providers/user_providers.dart';
import 'package:d_reader_flutter/features/auction_house/presentation/providers/auction_house_providers.dart';
import 'package:d_reader_flutter/features/auction_house/presentation/providers/listings_provider.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/features/nft/domain/models/buy_nft.dart';
import 'package:d_reader_flutter/features/nft/presentations/providers/nft_providers.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/solana/solana_transaction_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/ui/utils/candy_machine_utils.dart';
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

      final mintResult =
          await ref.read(solanaTransactionNotifierProvider.notifier).mint(
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
      ref.read(globalNotifierProvider.notifier).updateLoading(false);
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
          .read(solanaTransactionNotifierProvider.notifier)
          .buyMultiple(selectedNftsInput);
      ref.read(globalNotifierProvider.notifier).updateLoading(false);
      if (isSuccessful) {
        ref.invalidate(listingsPaginatedProvider);
      }
      displaySnackBar(
        text: isSuccessful ? 'Success!' : 'Failed to buy item(s).',
        isSuccess: isSuccessful,
      );
    } catch (exception) {
      ref.read(globalNotifierProvider.notifier).updateLoading(false);
      onException(exception);
    }
  }
}