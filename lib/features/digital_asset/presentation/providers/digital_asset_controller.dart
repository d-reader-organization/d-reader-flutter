import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/comic_issue_providers.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/providers/owned_issues_notifier.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/owned/owned_providers.dart';
import 'package:d_reader_flutter/features/digital_asset/domain/models/digital_asset.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/providers/digital_asset_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/domain/providers/solana/solana_transaction_notifier.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:flutter/animation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solana/solana.dart' show lamportsPerSol;
import 'package:video_player/video_player.dart';

part 'digital_asset_controller.g.dart';

@riverpod
class DigitalAssetController extends _$DigitalAssetController {
  @override
  void build() {}

  Future<void> delist({
    required String digitalAssetAddress,
    required void Function() callback,
    required void Function(Object exception) onException,
  }) async {
    try {
      final delistResult = await ref
          .read(solanaTransactionNotifierProvider.notifier)
          .delist(digitalAssetAddress: digitalAssetAddress);

      delistResult.fold((exception) {
        ref.read(privateLoadingProvider.notifier).update((state) => false);
        onException(exception);
      }, (result) async {
        if (result != successResult) {
          ref.read(privateLoadingProvider.notifier).update((state) => false);
          return onException(
            AppException(
              message: result,
              statusCode: 500,
              identifier: 'DigitalAssetController.delist',
            ),
          );
        }
        await Future.delayed(
          const Duration(milliseconds: 1200),
          () {
            ref.invalidate(digitalAssetProvider);
            ref.read(privateLoadingProvider.notifier).update((state) => false);
            callback();
          },
        );
      });
    } catch (exception) {
      ref.read(privateLoadingProvider.notifier).update((state) => false);
      onException(exception);
    }
  }

  Future<void> openDigitalAsset({
    required DigitalAssetModel digitalAsset,
    required void Function(String result) onOpen,
    required void Function(Object exception) onException,
  }) async {
    try {
      final useMintResult =
          await ref.read(solanaTransactionNotifierProvider.notifier).useMint(
                digitalAssetAddress: digitalAsset.address,
                ownerAddress: digitalAsset.ownerAddress,
              );
      useMintResult.fold(
          (exception) => onException(exception), (result) => onOpen(result));
    } catch (exception) {
      onException(exception);
    }
  }

  Future<void> listDigitalAsset({
    required String sellerAddress,
    required String mintAccount,
    required double price,
    required void Function(String result) callback,
  }) async {
    try {
      final response =
          await ref.read(solanaTransactionNotifierProvider.notifier).list(
                sellerAddress: sellerAddress,
                mintAccount: mintAccount,
                price: (price * lamportsPerSol).round(),
              );
      response.fold(
        (exception) {
          ref.read(privateLoadingProvider.notifier).update((state) => false);
          callback(exception.message);
        },
        (result) async {
          await Future.delayed(
            const Duration(milliseconds: 1200),
            () {
              ref.invalidate(digitalAssetProvider);
              ref
                  .read(privateLoadingProvider.notifier)
                  .update((state) => false);
              callback(result);
            },
          );
        },
      );
    } catch (exception) {
      ref.read(privateLoadingProvider.notifier).update((state) => false);
      rethrow;
    }
  }

  mintLoadingListener({
    required VideoPlayerController videoPlayerController,
    required AnimationController animationController,
    required Future Function(DigitalAssetModel digitalAsset) onSuccess,
    required Function() onTimeout,
    required Function([String message]) onFail,
  }) async {
    final transactionMessage =
        ref.watch(globalNotifierProvider).signatureMessage;

    final bool isMinted = ref.watch(lastProcessedAssetProvider) != null;
    if (videoPlayerController.value.isPlaying) {
      if (isMinted) {
        await _handleMintedCase(
          videoPlayerController: videoPlayerController,
          animationController: animationController,
          onSuccess: onSuccess,
        );
      } else if (transactionMessage ==
              TransactionStatusMessage.success.getString() &&
          !isMinted) {
        onFail(
            'Transaction is sent but not confirmed. Please use sync-wallet and check your wallet for the asset');
      } else if (transactionMessage ==
          TransactionStatusMessage.timeout.getString()) {
        onTimeout();
      } else if (transactionMessage ==
          TransactionStatusMessage.fail.getString()) {
        onFail();
      }
    } else if (transactionMessage ==
            TransactionStatusMessage.fail.getString() &&
        !isMinted) {
      onFail();
    }
  }

  _handleMintedCase({
    required VideoPlayerController videoPlayerController,
    required AnimationController animationController,
    required Future Function(DigitalAssetModel digitalAsset) onSuccess,
  }) async {
    videoPlayerController.pause();
    animationController.reverse(
      from: 1,
    );
    if (ref.watch(lastProcessedAssetProvider) == null) {
      return;
    }
    final digitalAsset = await ref.read(
        digitalAssetProvider(ref.watch(lastProcessedAssetProvider)!).future);

    if (digitalAsset == null) {
      return;
    }

    ref.invalidate(lastProcessedAssetProvider);
    ref.invalidate(ownedComicsProvider);
    ref.invalidate(ownedIssuesAsyncProvider);
    ref.invalidate(digitalAssetsProvider);
    ref
        .read(globalNotifierProvider.notifier)
        .update(isLoading: false, newMessage: '');
    await onSuccess(digitalAsset);
  }

  mintOpenListener({
    required VideoPlayerController videoPlayerController,
    required AnimationController animationController,
    required Function(int comicIssueId) onSuccess,
    required Function() onFail,
  }) {
    final bool isMinted = ref.watch(lastProcessedAssetProvider) != null;

    if (videoPlayerController.value.isPlaying) {
      if (isMinted) {
        _handleOpenedCase(
          animationController: animationController,
          onSuccess: onSuccess,
          videoPlayerController: videoPlayerController,
        );
      } else if (ref.watch(globalNotifierProvider).signatureMessage ==
          TransactionStatusMessage.fail.getString()) {
        onFail();
      }
    }
  }

  _handleOpenedCase({
    required VideoPlayerController videoPlayerController,
    required AnimationController animationController,
    required Function(int comicIssueId) onSuccess,
  }) {
    videoPlayerController.pause();
    animationController.reverse(
      from: 1,
    );
    final String? digitalAssetAddress = ref.read(lastProcessedAssetProvider);
    if (digitalAssetAddress == null) {
      return;
    }
    ref.invalidate(lastProcessedAssetProvider);
    ref.invalidate(digitalAssetsProvider);
    ref.invalidate(ownedComicsProvider);
    ref.invalidate(ownedIssuesAsyncProvider);
    ref.invalidate(comicIssuePagesProvider);
    ref.invalidate(comicIssueDetailsProvider);
    ref
        .read(globalNotifierProvider.notifier)
        .update(isLoading: false, newMessage: '');
    ref.read(digitalAssetProvider(digitalAssetAddress).future).then(
      (value) {
        if (value != null) {
          onSuccess(value.comicIssueId);
        }
      },
    );
  }

  handleDigitalAssetUnwrap({
    required String digitalAssetAddress,
    required String ownerAddress,
    required Function() onSuccess,
    required Function(String message) onFail,
  }) async {
    final useMintResult =
        await ref.read(solanaTransactionNotifierProvider.notifier).useMint(
              digitalAssetAddress: digitalAssetAddress,
              ownerAddress: ownerAddress,
            );
    useMintResult.fold((exception) => onFail(exception.message), (result) {
      if (result == successResult) {
        onSuccess();
      }
    });
  }
}
