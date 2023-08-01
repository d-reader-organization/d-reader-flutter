import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/logout_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_name_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_address.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/username_validator.dart';
import 'package:d_reader_flutter/ui/views/welcome.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/settings/list_tile.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ProfileView extends HookConsumerWidget {
  const ProfileView({Key? key}) : super(key: key);

  displaySnackBar({
    required BuildContext context,
    required Color color,
    required String text,
    Duration duration = const Duration(seconds: 1),
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color),
          borderRadius: BorderRadius.circular(
            8,
          ),
        ),
        duration: duration,
        closeIconColor: Colors.white,
        showCloseIcon: true,
        content: Text(
          text,
          style: TextStyle(color: color),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(myWalletProvider);
    final globalHook = useGlobalState();
    return SettingsScaffold(
      appBarTitle: 'Edit Profile',
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final String walletName = ref.watch(walletNameProvider);
          return AnimatedOpacity(
            opacity: walletName.isNotEmpty &&
                    walletName.trim() != provider.value?.name
                ? 1.0
                : 0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextButton(
                      size: const Size(double.infinity, 40),
                      onPressed: () {
                        final String walletName = ref.read(walletNameProvider);
                        if (walletName.isNotEmpty) {
                          ref.read(walletNameProvider.notifier).state = '';
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      backgroundColor: Colors.transparent,
                      textColor: const Color(0xFFEBEDF3),
                      borderColor: const Color(0xFFEBEDF3),
                      child: const Text('Cancel'),
                    ),
                  ),
                  Expanded(
                    child: CustomTextButton(
                      isLoading: ref.watch(globalStateProvider).isLoading,
                      size: const Size(double.infinity, 40),
                      onPressed: () async {
                        final String walletName = ref.read(walletNameProvider);
                        if (walletName.isNotEmpty) {
                          final notifier =
                              ref.read(globalStateProvider.notifier);
                          notifier.update(
                            (state) => state.copyWith(
                              isLoading: true,
                            ),
                          );
                          final result = await ref.read(
                            updateWalletProvider(
                              UpdateWalletPayload(
                                address: provider.value?.address ?? '',
                                name: walletName,
                              ),
                            ).future,
                          );
                          notifier.update(
                            (state) => state.copyWith(
                              isLoading: false,
                            ),
                          );
                          ref
                              .read(walletNameProvider.notifier)
                              .update((state) => '');
                          ref.invalidate(myWalletProvider);
                          if (context.mounted) {
                            displaySnackBar(
                              context: context,
                              color: result != null
                                  ? ColorPalette.dReaderGreen
                                  : ColorPalette.dReaderRed,
                              text: result != null
                                  ? 'Your wallet has been updated.'
                                  : 'Something went wrong',
                            );
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      body: provider.when(
        data: (wallet) {
          if (wallet == null) {
            return const SizedBox();
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Profile Image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        'Recommended image size: 500x500',
                        style: TextStyle(
                            fontSize: 14, color: ColorPalette.greyscale100),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Avatar(
                    wallet: wallet,
                    ref: ref,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return CustomTextField(
                        labelText: 'Username',
                        defaultValue:
                            wallet.name.isNotEmpty ? wallet.name : null,
                        onValidate: (value) {
                          return validateUsername(value: value, ref: ref);
                        },
                        onChange: (String value) {
                          ref.read(walletNameProvider.notifier).state = value;
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                    labelText: 'Wallet address',
                    defaultValue: formatAddress(wallet.address, 4),
                    isReadOnly: true,
                    suffix: SvgPicture.asset(
                      '${Config.settingsAssetsPath}/bold/copy.svg',
                    ),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: wallet.address))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Wallet address copied to clipboard",
                            ),
                          ),
                        );
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextButton(
                    size: const Size(double.infinity, 40),
                    borderRadius: BorderRadius.circular(8),
                    padding: EdgeInsets.zero,
                    textColor: Colors.black,
                    backgroundColor: ColorPalette.dReaderGreen,
                    isLoading: ref.watch(privateLoadingProvider),
                    onPressed: () async {
                      final loadingNotifier =
                          ref.read(privateLoadingProvider.notifier);
                      loadingNotifier.update((state) => true);
                      await ref.read(syncWalletProvider.future);
                      ref.invalidate(walletAssetsProvider);
                      loadingNotifier.update((state) => false);
                      if (context.mounted) {
                        displaySnackBar(
                          context: context,
                          color: ColorPalette.dReaderGreen,
                          text: 'Done',
                        );
                      }
                    },
                    child: const Text(
                      'Sync',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ref.read(environmentProvider).solanaCluster ==
                          SolanaCluster.devnet.value
                      ? SettingsCommonListTile(
                          title: 'Airdrop \$SOL',
                          leadingPath:
                              '${Config.settingsAssetsPath}/light/arrow_down.svg',
                          overrideColor:
                              ref.watch(globalStateProvider).isLoading
                                  ? ColorPalette.boxBackground400
                                  : ColorPalette.dReaderGreen,
                          overrideTrailing: globalHook.value.isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: ColorPalette.boxBackground400,
                                  ),
                                )
                              : null,
                          onTap: globalHook.value.isLoading
                              ? null
                              : () async {
                                  globalHook.value = globalHook.value
                                      .copyWith(isLoading: true);
                                  final airdropResult = await ref
                                      .read(solanaProvider.notifier)
                                      .requestAirdrop(wallet.address);

                                  globalHook.value = globalHook.value
                                      .copyWith(isLoading: false);
                                  if (context.mounted) {
                                    bool isSuccessful =
                                        airdropResult?.contains('SOL') ?? false;
                                    final Color snackBarColor = isSuccessful
                                        ? ColorPalette.dReaderGreen
                                        : ColorPalette.dReaderRed;
                                    return displaySnackBar(
                                      context: context,
                                      color: snackBarColor,
                                      text: isSuccessful
                                          ? airdropResult ??
                                              "Successfully airdropped 2 \$SOL "
                                          : 'Failed to airdrop 2 \$SOL',
                                      duration: const Duration(
                                        seconds: 2,
                                      ),
                                    );
                                  }
                                },
                        )
                      : const SizedBox(),
                  SettingsCommonListTile(
                    title: 'Disconnect wallet',
                    leadingPath:
                        '${Config.settingsAssetsPath}/light/logout.svg',
                    overrideColor: ColorPalette.dReaderRed,
                    onTap: () async {
                      await ref.read(logoutProvider.future);
                      if (context.mounted) {
                        nextScreenCloseOthers(context, const WelcomeView());
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
        error: (Object error, StackTrace stackTrace) {
          Sentry.captureException(error, stackTrace: stackTrace);
          return const Text('Something went wrong');
        },
        loading: () {
          return const SizedBox();
        },
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final WalletModel wallet;
  final WidgetRef ref;
  const Avatar({
    super.key,
    required this.wallet,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          File file = File(result.files.single.path ?? '');

          final notifier = ref.read(globalStateProvider.notifier);
          notifier.update(
            (state) => state.copyWith(
              isLoading: true,
            ),
          );
          final response = await ref.read(
            updateWalletAvatarProvider(
              UpdateWalletPayload(
                address: wallet.address,
                avatar: file,
              ),
            ).future,
          );
          ref.invalidate(myWalletProvider);
          Future.delayed(
            const Duration(milliseconds: 500),
            () {
              notifier.update(
                (state) => state.copyWith(
                  isLoading: false,
                ),
              );
            },
          );
          if (context.mounted && response != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Your avatar has been uploaded.'),
                duration: Duration(milliseconds: 500),
                backgroundColor: ColorPalette.dReaderGreen,
              ),
            );
          }
        }
      },
      child: ref.watch(globalStateProvider).isLoading
          ? Center(
              child: Container(
                height: 96,
                width: 96,
                padding: const EdgeInsets.all(16),
                child: const CircularProgressIndicator(
                  color: ColorPalette.dReaderBlue,
                ),
              ),
            )
          : wallet.avatar.isNotEmpty
              ? CircleAvatar(
                  radius: 48,
                  backgroundColor: ColorPalette.boxBackground300,
                  child: CachedNetworkImage(
                    imageUrl: wallet.avatar,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(64),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ))
              : Container(
                  padding: const EdgeInsets.all(16),
                  height: 96,
                  width: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(64),
                    border: Border.all(
                      color: ColorPalette.boxBackground400,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        '${Config.settingsAssetsPath}/bold/image.svg',
                      ),
                      const Text(
                        'Browse File',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(
                            0xFF777D8C,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
