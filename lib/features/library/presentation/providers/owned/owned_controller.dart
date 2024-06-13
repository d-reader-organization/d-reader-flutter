import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/owned/owned_providers.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/providers/digital_asset_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/domain/models/comic_issue.dart';
import 'package:d_reader_flutter/features/digital_asset/domain/models/digital_asset.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/mwa_transaction_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'owned_controller.g.dart';

@riverpod
class OwnedController extends _$OwnedController {
  @override
  void build() {}

  Future<List<DigitalAssetModel>> _fetchOwnedDigitalAssets(
      int comicIssueId) async {
    ref.read(globalNotifierProvider.notifier).updateLoading(true);

    final ownedDigitalAssets = await ref.read(digitalAssetsProvider(
      'comicIssueId=$comicIssueId&userId=${ref.read(environmentProvider).user?.id}',
    ).future);
    ref.read(globalNotifierProvider.notifier).updateLoading(false);
    return ownedDigitalAssets;
  }

  Future<void> handleIssueInfoTap({
    required int comicIssueId,
    required void Function(String digitalAssetAddress) goToDigitalAssetDetails,
  }) async {
    final List<DigitalAssetModel> ownedDigitalAssets =
        await _fetchOwnedDigitalAssets(comicIssueId);

    final int usedDigitalAssetIndex =
        ownedDigitalAssets.indexWhere((element) => element.isUsed);

    if (ownedDigitalAssets.length == 1) {
      final properIndex =
          usedDigitalAssetIndex > -1 ? usedDigitalAssetIndex : 0;
      goToDigitalAssetDetails(
          ownedDigitalAssets.elementAt(properIndex).address);
    }
    final ComicIssueModel? comicIssue = await ref.read(
      comicIssueDetailsProvider('$comicIssueId').future,
    );
    ref.read(selectedIssueInfoProvider.notifier).update((state) => comicIssue);
  }

  Future<void> handleOpenDigitalAsset({
    required DigitalAssetModel ownedDigitalAsset,
    required void Function() onSuccess,
    required void Function(String message) onFail,
  }) async {
    try {
      final openDigitalAssetResult =
          await ref.read(mwaTransactionNotifierProvider.notifier).useMint(
                digitalAssetAddress: ownedDigitalAsset.address,
                ownerAddress: ownedDigitalAsset.ownerAddress,
              );

      openDigitalAssetResult.fold((exception) => onFail(exception.message),
          (result) {
        if (result == successResult) {
          return onSuccess();
        }
        onFail(result);
      });
    } catch (exception) {
      rethrow;
    }
  }
}
