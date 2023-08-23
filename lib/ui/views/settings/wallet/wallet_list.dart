import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/core/states/environment_state.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_address.dart';
import 'package:d_reader_flutter/ui/utils/format_price.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/views/settings/wallet/wallet_info.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/install_wallet_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:solana/solana.dart' show Ed25519HDPublicKey;

class WalletListScreen extends ConsumerWidget {
  final int userId;
  const WalletListScreen({
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SvgPicture.asset(
                    'assets/icons/intro/splash_2.svg',
                    height: 281,
                    width: 238,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'No wallet detected',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    nextScreenPush(
                      context,
                      WalletInfoScreen(
                        address: data[index].address,
                        name: 'Wallet ${index + 1}',
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: ColorPalette.boxBackground300,
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                      border: ref.watch(selectedWalletProvider) ==
                              data[index].address
                          ? Border.all(color: ColorPalette.dReaderYellow100)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wallet ${index + 1}',
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
                                            '${formatLamportPrice((accountData.value?.lamports ?? 0))} \$ SOL',
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
                              GestureDetector(
                                onTap: () {
                                  ref
                                      .read(selectedWalletProvider.notifier)
                                      .update(
                                        (state) => data[index].address,
                                      );
                                  ref
                                      .read(environmentProvider.notifier)
                                      .updateEnvironmentState(
                                        EnvironmentStateUpdateInput(
                                          publicKey:
                                              Ed25519HDPublicKey.fromBase58(
                                            data[index].address,
                                          ),
                                        ),
                                      );
                                },
                                child: Icon(
                                  ref.watch(selectedWalletProvider) ==
                                          data[index].address
                                      ? Icons.circle
                                      : Icons.circle_outlined,
                                  color: ref.watch(selectedWalletProvider) ==
                                          data[index].address
                                      ? ColorPalette.dReaderYellow100
                                      : ColorPalette.boxBackground400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
          try {
            final result = await ref
                .read(solanaProvider.notifier)
                .authorizeAndSignMessage();

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
          } catch (error) {
            globalNotifier.update(
              (state) => state.copyWith(
                isLoading: false,
              ),
            );
            if (context.mounted) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.65,
                    minChildSize: 0.65,
                    maxChildSize: 0.8,
                    builder: (context, scrollController) {
                      return const InstallWalletBottomSheet();
                    },
                  );
                },
              );
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
