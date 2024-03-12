import 'dart:convert' show base64Decode, jsonEncode;

import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/features/candy_machine/presentations/providers/candy_machine_providers.dart';
import 'package:d_reader_flutter/features/nft/domain/models/buy_nft.dart';
import 'package:d_reader_flutter/features/nft/presentations/providers/nft_providers.dart';
import 'package:d_reader_flutter/features/transaction/domain/providers/transaction_provider.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/domain/providers/solana/solana_notifier.dart';
import 'package:d_reader_flutter/shared/exceptions/exceptions.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/utils/utils.dart';
import 'package:d_reader_flutter/ui/utils/candy_machine_utils.dart';
import 'package:d_reader_flutter/ui/utils/formatter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/encoder.dart';
import 'package:solana/solana.dart';
import 'package:solana_mobile_client/solana_mobile_client.dart';

part 'solana_transaction_notifier.g.dart';

@riverpod
class SolanaTransactionNotifier extends _$SolanaTransactionNotifier {
  @override
  void build() {}

  Future<bool> _isWalletEligibleForMint({
    required String candyMachineAddress,
    required String walletAddress,
  }) async {
    final candyMachineState = ref.read(candyMachineStateProvider);
    var activeGroup = getActiveGroup(candyMachineState?.groups ?? []);

    if (activeGroup == null || activeGroup.wallet?.supply == null) {
      final candyMachine = await ref.read(candyMachineProvider(
        query:
            'candyMachineAddress=$candyMachineAddress&walletAddress=$walletAddress',
      ).future);
      activeGroup = getActiveGroup(candyMachine?.groups ?? []);
      if (activeGroup == null) {
        return false;
      }
      return activeGroup.wallet != null && activeGroup.wallet!.isEligible;
    }
    return activeGroup.wallet != null && activeGroup.wallet!.isEligible;
  }

  Future<dynamic> _signAndSendMint({
    required List encodedNftTransactions,
    required MobileWalletAdapterClient client,
    required LocalAssociationScenario session,
  }) async {
    try {
      final response = await client.signTransactions(
        transactions: encodedNftTransactions.map((transaction) {
          return base64Decode(transaction);
        }).toList(),
      );
      if (response.signedPayloads.isNotEmpty) {
        final client = createSolanaClient(
          rpcUrl: ref.read(environmentProvider).solanaCluster ==
                  SolanaCluster.devnet.value
              ? Config.rpcUrlDevnet
              : Config.rpcUrlMainnet,
        );
        String sendTransactionResult = '';
        for (final signedPayload in response.signedPayloads) {
          final signedTx = SignedTx.fromBytes(
            signedPayload.toList(),
          );
          sendTransactionResult = await client.rpcClient.sendTransaction(
            signedTx.encode(),
            preflightCommitment: Commitment.confirmed,
          );
        }
        ref
            .read(globalNotifierProvider.notifier)
            .update(isLoading: false, isMinting: true);

        ref.read(mintingStatusProvider(sendTransactionResult));
        await session.close();
        return true;
      }
    } catch (exception) {
      await session.close();
      Sentry.captureException(
        exception,
        stackTrace:
            'User with ${ref.read(environmentProvider).user?.email} failed to sign and send mint.',
      );
      if (exception is JsonRpcException) {
        return exception.message;
      }
      await session.close();
      return false;
    }
  }

  Future<dynamic> mint(String? candyMachineAddress, String? label) async {
    if (candyMachineAddress == null) {
      return 'Candy machine not found.';
    }

    ref.read(globalNotifierProvider.notifier).updateLoading(true);
    final solanaNotifier = ref.read(solanaNotifierProvider.notifier);
    try {
      return await solanaNotifier.authorizeIfNeededWithOnComplete(
        onComplete: (client, session) async {
          final bool isReauthorized =
              await solanaNotifier.doReauthorize(client);
          if (!isReauthorized) {
            await session.close();
            return false;
          }

          final walletAddress =
              ref.read(environmentProvider).publicKey?.toBase58();
          if (walletAddress == null) {
            await session.close();
            return 'Missing wallet';
          }
          final isWalletEligibleForMint = await _isWalletEligibleForMint(
            candyMachineAddress: candyMachineAddress,
            walletAddress: walletAddress,
          );
          if (!isWalletEligibleForMint) {
            await session.close();
            return 'Wallet address ${Formatter.formatAddress(walletAddress, 3)} is not eligible for minting';
          }

          final response =
              await ref.read(transactionRepositoryProvider).mintOneTransaction(
                    candyMachineAddress: candyMachineAddress,
                    minterAddress: walletAddress,
                    label: label,
                  );
          return response.fold((exception) {
            return exception.message;
          }, (encodedNftTransactions) async {
            if (encodedNftTransactions.isEmpty) {
              await session.close();
              return false;
            }
            return _signAndSendMint(
              encodedNftTransactions: encodedNftTransactions,
              client: client,
              session: session,
            );
          });
        },
      );
    } catch (exception) {
      Sentry.captureException(
        exception is BadRequestException ? exception.cause : exception,
        stackTrace:
            'authorizeIfNeededWithOnComplete: ${ref.read(environmentProvider).user?.email}',
      );
      rethrow;
    }
  }

  Future<dynamic> _signAndSendTransactions({
    required MobileWalletAdapterClient client,
    required LocalAssociationScenario session,
    required List<String> encodedTransactions,
  }) async {
    ref.read(globalNotifierProvider.notifier).updateLoading(true);
    final solanaNotifier = ref.read(solanaNotifierProvider.notifier);
    final isReauthorized = await solanaNotifier.doReauthorize(client);

    if (!isReauthorized) {
      await session.close();
      return false;
    }

    try {
      final response = await client.signTransactions(
        transactions: encodedTransactions.map((transaction) {
          return base64Decode(transaction);
        }).toList(),
      );
      if (response.signedPayloads.isNotEmpty) {
        final client = createSolanaClient(
          rpcUrl: ref.read(environmentProvider).solanaCluster ==
                  SolanaCluster.devnet.value
              ? Config.rpcUrlDevnet
              : Config.rpcUrlMainnet,
        );

        final signedTx = SignedTx.fromBytes(
          response.signedPayloads.first.toList(),
        );
        final sendTransactionResult = await client.rpcClient.sendTransaction(
          signedTx.encode(),
          preflightCommitment: Commitment.confirmed,
        );
        ref
            .read(globalNotifierProvider.notifier)
            .update(isLoading: false, isMinting: true);
        ref.read(mintingStatusProvider(sendTransactionResult));
        await session.close();
        return true;
      }
    } catch (exception) {
      await session.close();
      Sentry.captureException(exception,
          stackTrace:
              'sign and send transaction: ${ref.read(environmentProvider).user?.email}');
      if (exception is JsonRpcException) {
        return exception.message;
      }
    }
  }

  Future<dynamic> list({
    required String sellerAddress,
    required String mintAccount,
    required int price,
    String printReceipt = 'false',
  }) async {
    final solanaNotifier = ref.read(solanaNotifierProvider.notifier);
    try {
      return await solanaNotifier.authorizeIfNeededWithOnComplete(
        onComplete: (client, session) async {
          final response =
              await ref.read(transactionRepositoryProvider).listTransaction(
                    sellerAddress: sellerAddress,
                    mintAccount: mintAccount,
                    price: price,
                    printReceipt: printReceipt,
                  );
          return response.fold((exception) => exception.message,
              (encodedTransaction) async {
            return await _signAndSendTransactions(
              client: client,
              session: session,
              encodedTransactions: [encodedTransaction],
            );
          });
        },
      );
    } catch (exception) {
      if (exception is LowPowerModeException ||
          exception is NoWalletFoundException) {
        rethrow;
      }
      Sentry.captureException(exception,
          stackTrace:
              'List failed. Seller $sellerAddress, mintAccount $mintAccount - user with ${ref.read(environmentProvider).user?.email}');
      return false;
    }
  }

  Future<dynamic> delist({
    required String nftAddress,
  }) async {
    final solanaNotifier = ref.read(solanaNotifierProvider.notifier);
    try {
      return await solanaNotifier.authorizeIfNeededWithOnComplete(
        onComplete: (client, session) async {
          final response = await ref
              .read(transactionRepositoryProvider)
              .cancelListingTransaction(nftAddress: nftAddress);

          return response.fold((exception) => exception.message,
              (encodedTransaction) async {
            return await _signAndSendTransactions(
              client: client,
              session: session,
              encodedTransactions: [encodedTransaction],
            );
          });
        },
      );
    } catch (exception) {
      if (exception is LowPowerModeException ||
          exception is NoWalletFoundException) {
        rethrow;
      }
      Sentry.captureException(exception,
          stackTrace:
              'Delist failed for ${ref.read(environmentProvider).user?.email}.');
      return false;
    }
  }

  Future<bool> buyMultiple(List<BuyNftInput> input) async {
    final solanaNotifier = ref.read(solanaNotifierProvider.notifier);
    try {
      final result = await solanaNotifier.authorizeIfNeededWithOnComplete(
        onComplete: (client, session) async {
          Map<String, String> query = {};
          for (int i = 0; i < input.length; ++i) {
            query["instantBuyParams[$i]"] = jsonEncode(input[i].toJson());
          }
          final response = await ref
              .read(transactionRepositoryProvider)
              .buyMultipleItems(query);
          return response.fold((exception) => exception.message,
              (encodedTransactions) async {
            if (encodedTransactions.isEmpty) {
              return false;
            }
            return await _signAndSendTransactions(
              client: client,
              session: session,
              encodedTransactions: encodedTransactions,
            );
          });
        },
      );
      return result.fold((exception) => false, (data) => data == 'OK');
    } catch (exception) {
      if (exception is LowPowerModeException ||
          exception is NoWalletFoundException) {
        rethrow;
      }
      Sentry.captureException(exception,
          stackTrace:
              'Buy multiple failed for ${ref.read(environmentProvider).user?.email}');
      return false;
    }
  }

  Future<dynamic> useMint({
    required String nftAddress,
    required String ownerAddress,
  }) async {
    final solanaNotifier = ref.read(solanaNotifierProvider.notifier);
    try {
      return await solanaNotifier.authorizeIfNeededWithOnComplete(
        onComplete: (client, session) async {
          final response = await ref
              .read(transactionRepositoryProvider)
              .useComicIssueNftTransaction(
                nftAddress: nftAddress,
                ownerAddress: ownerAddress,
              );
          return response.fold(
            (exception) => exception.message,
            (transaction) async {
              return await _signAndSendTransactions(
                client: client,
                session: session,
                encodedTransactions: [transaction],
              );
            },
          );
        },
      );
    } catch (exception) {
      if (exception is LowPowerModeException ||
          exception is NoWalletFoundException) {
        rethrow;
      }
      Sentry.captureException(exception,
          stackTrace:
              'Failed to use mint: nftAddress $nftAddress, owner: $ownerAddress. User: ${ref.read(environmentProvider).user?.email}');
      return false;
    }
  }
}
