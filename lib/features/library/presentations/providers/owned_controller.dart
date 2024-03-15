import 'package:d_reader_flutter/features/comic_issue/presentation/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/library/presentations/providers/owned_providers.dart';
import 'package:d_reader_flutter/features/nft/presentations/providers/nft_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/solana/solana_transaction_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'owned_controller.g.dart';

@riverpod
class OwnedController extends _$OwnedController {
  @override
  void build() {}

  Future<List<NftModel>> _fetchOwnedNfts(int comicIssueId) async {
    ref.read(globalNotifierProvider.notifier).updateLoading(true);

    final ownedNfts = await ref.read(nftsProvider(
      'comicIssueId=$comicIssueId&userId=${ref.read(environmentProvider).user?.id}',
    ).future);
    ref.read(globalNotifierProvider.notifier).updateLoading(false);
    return ownedNfts;
  }

  Future<void> handleIssueInfoTap({
    required int comicIssueId,
    required void Function(String nftAddress) goToNftDetails,
  }) async {
    final List<NftModel> ownedNfts = await _fetchOwnedNfts(comicIssueId);

    final int usedNftIndex = ownedNfts.indexWhere((element) => element.isUsed);

    if (ownedNfts.length == 1) {
      final properIndex = usedNftIndex > -1 ? usedNftIndex : 0;
      goToNftDetails(ownedNfts.elementAt(properIndex).address);
    }
    final ComicIssueModel? comicIssue = await ref.read(
      comicIssueDetailsProvider(comicIssueId).future,
    );
    ref.read(selectedIssueInfoProvider.notifier).update((state) => comicIssue);
  }

  Future<void> handleOpenNft({
    required NftModel ownedNft,
    required void Function() onSuccess,
    required void Function(String message) onFail,
  }) async {
    try {
      final openNftResult =
          await ref.read(solanaTransactionNotifierProvider.notifier).useMint(
                nftAddress: ownedNft.address,
                ownerAddress: ownedNft.ownerAddress,
              );

      openNftResult.fold((exception) => onFail(exception.message), (result) {
        if (result == 'OK') {
          return onSuccess();
        }
        onFail(result);
      });
    } catch (exception) {
      rethrow;
    }
  }
}
