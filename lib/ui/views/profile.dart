import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/providers/logout_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/welcome.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:d_reader_flutter/ui/widgets/settings/list_tile.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:d_reader_flutter/ui/widgets/settings/text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart' as fcm;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

class ProfileView extends ConsumerWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(myWalletProvider);
    return SettingsScaffold(
      appBarTitle: 'Edit Wallet',
      body: provider.when(
        data: (wallet) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
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
                    wallet: wallet!,
                    ref: ref,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const SettingsTextField(
                    labelText: 'Account name',
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SettingsTextField(
                    labelText: 'Wallet address',
                    defaultValue: wallet.address,
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
                    height: 16,
                  ),
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
          print('Error in profile view ${error.toString()}');
          return const Text('Something went wrong');
        },
        loading: () {
          return const SizedBox();
        },
      ),
    );
  }
}

class WalletSkeleton extends StatelessWidget {
  const WalletSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SkeletonRow(),
        SizedBox(
          height: 8,
        ),
        SkeletonRow(),
        SizedBox(
          height: 8,
        ),
        SkeletonRow(),
      ],
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
          final bytes = await file.readAsBytes();
          await ref.read(
            updateWalletAvatarProvider(
              UpdateWalletPayload(
                address: wallet.address,
                avatar: http.MultipartFile.fromBytes(
                  'avatar',
                  bytes,
                  filename: 'avatar.jpg',
                ),
              ),
            ).future,
          );
          ref.invalidate(myWalletProvider);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Your avatar has been uploaded.'),
                duration: Duration(milliseconds: 500),
              ),
            );
          }
        }
      },
      child: wallet.avatar.isNotEmpty
          ? CircleAvatar(
              radius: 48,
              backgroundColor: Colors.transparent,
              child: CachedNetworkImage(
                imageUrl: wallet.avatar,
                cacheKey: wallet.address,
                cacheManager: fcm.CacheManager(
                  fcm.Config(
                    wallet.address,
                    stalePeriod: const Duration(days: 1),
                  ),
                ),
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
