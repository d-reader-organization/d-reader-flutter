import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/core/utils/utils.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_address.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';
part 'wallet.g.dart';

@riverpod
Future<AccountResult> accountInfo(
  AccountInfoRef ref, {
  required String address,
}) {
  final client = createSolanaClient(
    rpcUrl: ref.read(environmentProvider).solanaCluster ==
            SolanaCluster.devnet.value
        ? Config.rpcUrlDevnet
        : Config.rpcUrlMainnet,
  );
  return client.rpcClient.getAccountInfo(address);
}

class WalletScreen extends ConsumerWidget {
  final int userId;
  const WalletScreen({
    super.key,
    required this.userId,
  });

  final topTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  final bottomTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: ColorPalette.greyscale100,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsProvider = ref.watch(
      userWalletsProvider(
        id: userId,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Wallet',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: walletsProvider.when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(
                child: Text(
                  'User does not have a connected wallet',
                ),
              );
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: ColorPalette.boxBackground300,
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wallet 1',
                            style: topTextStyle,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            formatAddress(data[index].address, 4),
                            style: bottomTextStyle,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 48,
                        child: VerticalDivider(
                          color: ColorPalette.boxBackground400,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ref
                                    .watch(
                                  accountInfoProvider(
                                    address: data[index].address,
                                  ),
                                )
                                    .when(
                                  data: (accountData) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${(accountData.value?.lamports ?? 0) / lamportsPerSol}',
                                          style: topTextStyle,
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          '${(accountData.value?.lamports ?? 0) / lamportsPerSol} SOL',
                                          style: bottomTextStyle,
                                        ),
                                      ],
                                    );
                                  },
                                  error: (error, stackTrace) {
                                    return const SizedBox();
                                  },
                                  loading: () {
                                    return const SizedBox();
                                  },
                                ),
                              ],
                            ),
                            SvgPicture.asset('assets/icons/more.svg'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) {
            Sentry.captureException(error, stackTrace: stackTrace);
            return const Center(
              child: Text('Something went wrong'),
            );
          },
          loading: () => const SizedBox(),
        ),
      ),
      bottomNavigationBar: CustomTextButton(
        borderRadius: BorderRadius.circular(8),
        onPressed: () async {
          final globalNotifier = ref.read(globalStateProvider.notifier);
          globalNotifier.update(
            (state) => state.copyWith(
              isLoading: true,
            ),
          );
          final result =
              await ref.read(solanaProvider.notifier).authorizeAndSignMessage();

          globalNotifier.update(
            (state) => state.copyWith(
              isLoading: false,
            ),
          );
          final bool isConnected = result == 'OK';
          if (context.mounted) {
            showSnackBar(
              context: context,
              text: isConnected
                  ? 'Wallet has been connected.'
                  : 'Something went wrong',
            );
            if (isConnected) {
              ref.invalidate(userWalletsProvider);
            }
          }
        },
        size: const Size(double.infinity, 50),
        isLoading: ref.watch(globalStateProvider).isLoading,
        padding: const EdgeInsets.all(16),
        child: const Text(
          'Add / Connect Wallet',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
