import 'package:d_reader_flutter/core/providers/comic_issue_provider.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/library/selected_owned_comic_provider.dart';
import 'package:d_reader_flutter/core/providers/nft_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'owned_controller.g.dart';

@riverpod
class OwnedController extends _$OwnedController {
  late StateController<GlobalState> globalNotifier;
  @override
  FutureOr<void> build() {
    globalNotifier = ref.read(globalStateProvider.notifier);
  }

  Future<List<NftModel>> _fetchOwnedNfts(int comicIssueId) async {
    final globalNotifier = ref.read(globalStateProvider.notifier);
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    final ownedNfts = await ref.read(nftsProvider(
      'comicIssueId=$comicIssueId&userId=${ref.read(environmentProvider).user?.id}',
    ).future);
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: false,
      ),
    );
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
      final isSuccessful = await ref.read(solanaProvider.notifier).useMint(
            nftAddress: ownedNft.address,
            ownerAddress: ownedNft.ownerAddress,
          );
      if (isSuccessful) {
        return onSuccess();
      }
      onFail('Failed to open');
    } catch (exception) {
      rethrow;
    }
  }
}
