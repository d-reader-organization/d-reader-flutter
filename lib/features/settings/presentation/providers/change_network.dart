import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/enums.dart';
import 'package:d_reader_flutter/features/comic/presentation/providers/comic_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/creator/presentation/providers/creator_providers.dart';
import 'package:d_reader_flutter/features/home/carousel/presentation/providers/carousel_providers.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/favorites/favorites_providers.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/owned/owned_providers.dart';
import 'package:d_reader_flutter/features/settings/presentation/providers/spl_tokens.dart';
import 'package:d_reader_flutter/shared/data/local/local_store.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/state/environment_state.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/scaffold_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'change_network.g.dart';

@riverpod
class ChangeNetworkController extends _$ChangeNetworkController {
  @override
  void build() {}

  void _invalidateChangeNetworkData() {
    ref.invalidate(comicsProvider);
    ref.invalidate(comicIssuesProvider);
    ref.invalidate(creatorsProvider);
    ref.invalidate(carouselProvider);
    ref.invalidate(paginatedIssuesProvider);
    ref.invalidate(paginatedComicsProvider);
    ref.invalidate(ownedComicsProvider);
    ref.invalidate(favoriteComicsProvider);
    ref.invalidate(splTokensProvider);
  }

  _doChangeNetworkProcess({
    required String cluster,
    required String dialogText,
    required void Function({
      required bool isSuccess,
      required String text,
    }) triggerChangeDialog,
    required void Function() triggerScreenChange,
  }) {
    final dynamic localStoreData = ref.read(
      localStoreNetworkDataProvider(cluster),
    );
    final bool isDevnetCluster = cluster == SolanaCluster.devnet.value;
    ref.invalidate(environmentProvider);
    final envNotifier = ref.read(environmentProvider.notifier);
    envNotifier.updateForChangeNetwork(
      cluster: cluster,
    );
    if (localStoreData != null) {
      bool isSuccessful =
          ref.read(environmentProvider.notifier).updateEnvironmentState(
                EnvironmentStateUpdateInput.fromDynamic(
                  localStoreData,
                ),
              );

      final snackbarText = isSuccessful
          ? 'Network changed successfully'
          : 'Network change failed.';
      if (!isSuccessful) {
        ref.read(environmentProvider.notifier).updateEnvironmentState(
              EnvironmentStateUpdateInput(
                solanaCluster: isDevnetCluster
                    ? SolanaCluster.mainnet.value
                    : SolanaCluster.devnet.value,
              ),
            );
        return triggerChangeDialog(isSuccess: false, text: snackbarText);
      }
      _invalidateChangeNetworkData();
      return triggerChangeDialog(
        isSuccess: true,
        text: snackbarText,
      );
    } else {
      ref.invalidate(scaffoldNavigationIndexProvider);
      _invalidateChangeNetworkData();
      triggerScreenChange();
    }
  }

  Future<void> handleNetworkChange({
    required String cluster,
    required String dialogText,
    required Future<bool> Function({
      required String subtitle,
      required String cluster,
    }) showConfirmDialog,
    required void Function({
      required bool isSuccess,
      required String text,
    }) triggerChangeDialog,
    required void Function() triggerScreenChange,
  }) async {
    final isAlreadyShown =
        LocalStore.instance.get(WalkthroughKeys.changeNetwork.name) != null;
    if (isAlreadyShown) {
      return _doChangeNetworkProcess(
        cluster: cluster,
        dialogText: dialogText,
        triggerChangeDialog: triggerChangeDialog,
        triggerScreenChange: triggerScreenChange,
      );
    }

    final isConfirmed = await showConfirmDialog(
      cluster: cluster,
      subtitle: dialogText,
    );
    if (isConfirmed) {
      LocalStore.instance.put(WalkthroughKeys.changeNetwork.name, true);
      _doChangeNetworkProcess(
        cluster: cluster,
        dialogText: dialogText,
        triggerChangeDialog: triggerChangeDialog,
        triggerScreenChange: triggerScreenChange,
      );
    }
  }
}
