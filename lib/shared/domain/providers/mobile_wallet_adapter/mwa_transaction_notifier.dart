import 'dart:convert' show base64Decode, jsonEncode;

import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/auction_house/presentation/providers/auction_house_providers.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine_group.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/features/digital_asset/domain/models/buy_digital_asset.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/providers/digital_asset_providers.dart';
import 'package:d_reader_flutter/features/transaction/domain/providers/transaction_provider.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/mwa_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/solana_providers.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/utils/formatter.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

part 'mwa_transaction_notifier.g.dart';

bool hasEligibilityForMint(CandyMachineGroupModel? group) {
  if (group == null) {
    return false;
  }
  if (group.user != null) {
    return group.user!.isEligible;
  }
  return group.wallet != null && group.wallet!.isEligible;
}

@riverpod
class MwaTransactionNotifier extends _$MwaTransactionNotifier {
  @override
  void build() {}

  Future<Either<AppException, String>> _signAndSendMint({
    required List<Uint8List> transactions,
    required MobileWalletAdapterClient client,
    required LocalAssociationScenario session,
  }) async {
    try {
      final response = await client.signTransactions(
        transactions: transactions,
      );
      if (response.signedPayloads.isEmpty) {
        return Left(
          AppException(
            message: 'Failed to sign transactions',
            identifier: 'SolanaTransactionNotifier._signAndSendMint',
            statusCode: 500,
          ),
        );
      }
      final solanaClient = ref.read(solanaClientProvider);
      String sendTransactionResult = '';
      for (final signedPayload in response.signedPayloads) {
        final signedTx = SignedTx.fromBytes(
          signedPayload.toList(),
        );
        sendTransactionResult = await solanaClient.rpcClient.sendTransaction(
          signedTx.encode(),
          skipPreflight: true,
        );
      }
      ref.read(globalNotifierProvider.notifier).update(
          isLoading: false,
          newMessage: TransactionStatusMessage.waiting.getString());

      ref.read(transactionChainStatusProvider(sendTransactionResult));
      await session.close();
      return const Right(successResult);
    } catch (exception) {
      await session.close();
      Sentry.captureException(
        exception,
        stackTrace:
            'User with ${ref.read(environmentProvider).user?.email} failed to sign and send mint.',
      );
      if (exception is JsonRpcException) {
        return Left(
          AppException(
            message: exception.message,
            identifier: 'SolanaTransactionNotifier._signAndSendMint',
            statusCode: 500,
          ),
        );
      }

      return Left(
        AppException(
          message:
              'Unknown error occurred and report has been sent to our development team.',
          identifier: 'SolanaTransactionNotifier._signAndSendMint',
          statusCode: 500,
        ),
      );
    }
  }

  String _noEligibilityMessage() {
    final isUser = ref.read(selectedCandyMachineGroup)?.user != null;
    return isUser
        ? 'User ${ref.read(environmentProvider).user?.email} is not eligible for minting'
        : 'Wallet address ${Formatter.formatAddress(ref.read(selectedWalletProvider), 3)} is not eligible for minting';
  }

  Future<Either<AppException, String>> mint(
    List<Uint8List> transactions,
  ) async {
    final solanaNotifier = ref.read(mwaNotifierProvider.notifier);
    try {
      return await solanaNotifier.authorizeIfNeededWithOnComplete(
        onComplete: (client, session) async {
          final bool isReauthorized =
              await solanaNotifier.doReauthorize(client);
          if (!isReauthorized) {
            await session.close();
            return Left(
              AppException(
                identifier: 'SolanaTransactionNotifier.mint',
                message: 'Failed to reauthorize wallet',
                statusCode: 403,
              ),
            );
          }

          if (!hasEligibilityForMint(ref.read(selectedCandyMachineGroup))) {
            // have to keep it inside MWA session.
            return Left(
              AppException(
                identifier: 'SolanaTransactionNotifier.mint',
                message: _noEligibilityMessage(),
                statusCode: 401,
              ),
            );
          }

          final signAndSendMintResult = await _signAndSendMint(
            transactions: transactions,
            client: client,
            session: session,
          );
          return signAndSendMintResult.fold(
            (exception) => Left(exception),
            (result) => Right(result),
          );
        },
      );
    } catch (exception) {
      Sentry.captureException(
        exception is BadRequestException ? exception.cause : exception,
        stackTrace:
            'authorizeIfNeededWithOnComplete: ${ref.read(environmentProvider).user?.email}',
      );
      return Left(
        AppException(
          identifier: 'SolanaTransactionNotifier.mint.catchBlock',
          message: 'Failed to mint',
          statusCode: 500,
        ),
      );
    }
  }

  Future<Either<AppException, String>> _signAndSendTransactions({
    required MobileWalletAdapterClient client,
    required LocalAssociationScenario session,
    required List<Uint8List> transactions,
  }) async {
    ref.read(globalNotifierProvider.notifier).updateLoading(true);
    final mwaNotifier = ref.read(mwaNotifierProvider.notifier);
    final isReauthorized = await mwaNotifier.doReauthorize(client);

    if (!isReauthorized) {
      await session.close();
      ref.read(globalNotifierProvider.notifier).updateLoading(false);
      return Left(
        AppException(
          identifier: 'mwaNotifier._signAndSendTransactions',
          message: 'Failed to reauthorize wallet',
          statusCode: 401,
        ),
      );
    }

    try {
      final response = await client.signTransactions(
        transactions: transactions,
      );
      if (response.signedPayloads.isEmpty) {
        ref.read(globalNotifierProvider.notifier).updateLoading(false);
        return Left(
          AppException(
            identifier: 'mwaNotifier._signAndSendTransactions',
            message: 'Failed to reauthorize wallet',
            statusCode: 401,
          ),
        );
      }
      final solanaClient = ref.read(solanaClientProvider);

      final signedTx = SignedTx.fromBytes(
        response.signedPayloads.first.toList(),
      );
      final sendTransactionResult =
          await solanaClient.rpcClient.sendTransaction(
        signedTx.encode(),
        skipPreflight: true,
      );
      ref.read(globalNotifierProvider.notifier).update(
            isLoading: false,
            newMessage: TransactionStatusMessage.waiting.getString(),
          );
      ref.read(transactionChainStatusProvider(sendTransactionResult));
      await session.close();
      return const Right(successResult);
    } catch (exception) {
      await session.close();
      ref.read(globalNotifierProvider.notifier).updateLoading(false);
      return Left(
        AppException(
          identifier: 'mwaNotifier.signAndSendTransactions',
          message: exception is JsonRpcException
              ? exception.message
              : 'Failed to sign and send transactions',
          statusCode: 500,
        ),
      );
    }
  }

  Future<Either<AppException, String>> signAndSendWithWrapper(
      List<Uint8List> transactions) async {
    final solanaNotifier = ref.read(mwaNotifierProvider.notifier);
    try {
      return await solanaNotifier.authorizeIfNeededWithOnComplete(
        onComplete: (client, session) async {
          return await _signAndSendTransactions(
            client: client,
            session: session,
            transactions: transactions,
          );
        },
      );
    } catch (exception) {
      if (exception is AppException) {
        return Left(exception);
      }

      return Left(
        AppException(
          identifier: 'SolanaTransactionNotifier.signAndSendWithWrapper',
          statusCode: 500,
          message: 'Failed to sign and send transactions.',
        ),
      );
    }
  }

  Future<Either<AppException, String>> buyMultiple() async {
    final solanaNotifier = ref.read(mwaNotifierProvider.notifier);
    try {
      return await solanaNotifier.authorizeIfNeededWithOnComplete(
        onComplete: (client, session) async {
          final activeWallet =
              ref.read(environmentProvider).publicKey?.toBase58();
          if (activeWallet == null) {
            return Left(
              AppException(
                message: 'Failed to connect wallet',
                identifier: 'SolanaTransactionNotifier.buyMultiple',
                statusCode: 500,
              ),
            );
          }
          List<BuyDigitalAsset> selectedDigitalAssetsInput = ref
              .read(selectedListingsProvider)
              .map(
                (e) => BuyDigitalAsset(
                  mintAccount: e.assetAddress,
                  price: e.price,
                  sellerAddress: e.seller.address,
                  buyerAddress: activeWallet,
                ),
              )
              .toList();
          Map<String, String> query = {};
          for (int i = 0; i < selectedDigitalAssetsInput.length; ++i) {
            query["instantBuyParams[$i]"] =
                jsonEncode(selectedDigitalAssetsInput[i].toJson());
          }
          final response = await ref
              .read(transactionRepositoryProvider)
              .buyMultipleItems(query);
          return response.fold((exception) async {
            await session.close();
            return Left(exception);
          }, (encodedTransactions) async {
            if (encodedTransactions.isEmpty) {
              return Left(
                AppException(
                  message: 'Failed to get transactions from API',
                  identifier: 'SolanaTransactionNotifier.buyMultiple',
                  statusCode: 500,
                ),
              );
            }
            return await _signAndSendTransactions(
              client: client,
              session: session,
              transactions: encodedTransactions.map(base64Decode).toList(),
            );
          });
        },
      );
    } catch (exception) {
      if (exception is AppException) {
        return Left(exception);
      }

      Sentry.captureException(exception,
          stackTrace:
              'Buy multiple failed for ${ref.read(environmentProvider).user?.email}');
      return Left(
        AppException(
          identifier: 'SolanaTransactionNotifier.list',
          statusCode: 500,
          message: 'Failed to delist digital asset.',
        ),
      );
    }
  }

  Future<Either<AppException, String>> useMint({
    required String digitalAssetAddress,
    required String ownerAddress,
  }) async {
    final solanaNotifier = ref.read(mwaNotifierProvider.notifier);
    ref.read(globalNotifierProvider.notifier).updateLoading(true);

    try {
      final response = await ref
          .read(transactionRepositoryProvider)
          .useComicIssueAssetTransaction(
            digitalAssetAddress: digitalAssetAddress,
            ownerAddress: ownerAddress,
          );

      return response.fold(
        (exception) async {
          ref.read(globalNotifierProvider.notifier).updateLoading(false);
          return Left(exception);
        },
        (transaction) async {
          // if there is no transaction, that means it's Core Digital Asset which means it's unwrapped
          if (transaction == null || transaction.isEmpty) {
            ref
                .read(lastProcessedAssetProvider.notifier)
                .update((state) => digitalAssetAddress);
            ref.read(globalNotifierProvider.notifier).updateLoading(false);
            return const Right(successResult);
          }
          return await solanaNotifier.authorizeIfNeededWithOnComplete(
            onComplete: (client, session) async {
              return await _signAndSendTransactions(
                client: client,
                session: session,
                transactions: [base64Decode(transaction)],
              );
            },
          );
        },
      );
    } catch (exception) {
      if (exception is AppException) {
        return Left(exception);
      }

      Sentry.captureException(exception,
          stackTrace:
              'Failed to use mint: digitalAssetAddress $digitalAssetAddress, owner: $ownerAddress. User: ${ref.read(environmentProvider).user?.email}');
      return Left(
        AppException(
          identifier: 'SolanaTransactionNotifier.list',
          statusCode: 500,
          message: 'Failed to unwrap digitalAssetAddress',
        ),
      );
    }
  }
}
