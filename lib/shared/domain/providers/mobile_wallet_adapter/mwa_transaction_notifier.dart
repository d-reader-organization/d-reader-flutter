import 'dart:convert';

import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/features/candy_machine/domain/models/candy_machine_coupon.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/notifiers/candy_machine_notifier.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/providers/digital_asset_providers.dart';
import 'package:d_reader_flutter/features/transaction/domain/providers/transaction_provider.dart';
import 'package:d_reader_flutter/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:d_reader_flutter/features/transaction/presentation/providers/common/transaction_state.dart';
import 'package:d_reader_flutter/features/wallet/presentation/providers/wallet_providers.dart';
import 'package:d_reader_flutter/shared/domain/models/either.dart';
import 'package:d_reader_flutter/shared/domain/models/enums.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/mwa_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/mobile_wallet_adapter/solana_providers.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

part 'mwa_transaction_notifier.g.dart';

bool hasEligibilityForMint(CandyMachineCoupon? coupon) {
  return coupon != null && coupon.stats.isEligible;
}

@riverpod
class MwaTransactionNotifier extends _$MwaTransactionNotifier {
  late final TransactionRepository _transactionRepository;
  @override
  void build() {
    _transactionRepository = ref.read(transactionRepositoryProvider);
  }

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
            identifier: 'MwaTransactionNotifier._signAndSendMint',
            statusCode: 500,
          ),
        );
      }
      final encodedTransactions = response.signedPayloads
          .map((signedPayload) => SignedTx.fromBytes(signedPayload.toList()))
          .map((item) => item.encode())
          .toList();

      final walletAddress =
          ref.read(environmentProvider).publicKey?.toBase58() ?? '';
      final result = await _transactionRepository.sendMintTransaction(
        walletAddress: walletAddress,
        transactions: encodedTransactions,
      );
      return result.fold(
        (exception) => Left(exception),
        (data) async {
          await session.close();
          return const Right(successResult);
        },
      );
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
            identifier: 'MwaTransactionNotifier._signAndSendMint',
            statusCode: 500,
          ),
        );
      }

      return Left(
        AppException(
          message:
              'Unknown error occurred and report has been sent to our development team.',
          identifier: 'MwaTransactionNotifier._signAndSendMint',
          statusCode: 500,
        ),
      );
    }
  }

  String _noEligibilityMessage() {
    return 'User ${ref.read(environmentProvider).user?.email} is not eligible for minting';
  }

  Future<TransactionApiResponse<List<String>>> _getMintTransactions(
      String candyMachineAddress) async {
    final data = ref.read(candyMachineNotifierProvider);
    return ref
        .read(transactionRepositoryProvider)
        .mintTransaction(
          couponId: data.selectedCoupon?.id ?? 1,
          numberOfItems: data.numberOfItems,
          candyMachineAddress: candyMachineAddress,
          minterAddress: ref.read(selectedWalletProvider),
          label: data.selectedCurrency?.label,
        )
        .then(mapApiResponse);
  }

  Future<Either<AppException, String>> mint(String candyMachineAddress) async {
    final mwaNotifier = ref.read(mwaNotifierProvider.notifier);
    try {
      return await mwaNotifier.authorizeIfNeededWithOnComplete(
        onComplete: (client, session) async {
          final bool isReauthorized = await mwaNotifier.doReauthorize(client);
          if (!isReauthorized) {
            await session.close();
            return Left(
              AppException(
                identifier: 'MwaTransactionNotifier.mint',
                message: 'Failed to reauthorize wallet',
                statusCode: 403,
              ),
            );
          }

          if (!hasEligibilityForMint(
              ref.read(candyMachineNotifierProvider).selectedCoupon)) {
            // have to keep it inside MWA session.
            return Left(
              AppException(
                identifier: 'MwaTransactionNotifier.mint',
                message: _noEligibilityMessage(),
                statusCode: 401,
              ),
            );
          }

          final transactionsResponse =
              await _getMintTransactions(candyMachineAddress);

          return transactionsResponse.when(
            ok: (data) async {
              final signAndSendMintResult = await _signAndSendMint(
                transactions: data.map(base64Decode).toList(),
                client: client,
                session: session,
              );
              return signAndSendMintResult.fold(
                (exception) => Left(exception),
                (result) => Right(result),
              );
            },
            error: (message) => Left(
              AppException(
                message: message,
                identifier: '',
                statusCode: 500,
              ),
            ),
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
          identifier: 'MwaTransactionNotifier.mint.catchBlock',
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
    List<Uint8List> transactions,
  ) async {
    final mwaNotifier = ref.read(mwaNotifierProvider.notifier);
    try {
      return await mwaNotifier.authorizeIfNeededWithOnComplete(
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
          identifier: 'MwaTransactionNotifier.signAndSendWithWrapper',
          statusCode: 500,
          message: 'Failed to sign and send transactions.',
        ),
      );
    }
  }
}
