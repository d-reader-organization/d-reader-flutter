import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/providers/auth_provider.dart';
import 'package:d_reader_flutter/core/providers/scaffold_provider.dart';
import 'package:d_reader_flutter/core/providers/solana_client_provider.dart';
import 'package:d_reader_flutter/core/providers/tab_bar_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_address.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/views/settings/edit_wallet_name.dart';
import 'package:d_reader_flutter/ui/views/welcome.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:d_reader_flutter/ui/widgets/settings/container.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

class ProfileView extends ConsumerWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(myWalletProvider);
    return SettingsScaffold(
      appBarTitle: 'Edit Account',
      body: provider.when(
        data: (wallet) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Avatar(
                  wallet: wallet!,
                  ref: ref,
                ),
                const SizedBox(
                  height: 24,
                ),
                SettingsContainer(
                  onPressed: () {
                    nextScreenPush(
                      context,
                      EditWalletName(
                        wallet: wallet,
                      ),
                    );
                  },
                  leftWidget: const Text(
                    'Account Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  rightWidget: Row(
                    children: [
                      Text(
                        wallet.label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_right,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                SettingsContainer(
                  onPressed: () {},
                  leftWidget: const Text(
                    'Account Address',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  rightWidget: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      formatAddress(wallet.address, 4),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const SettingsContainer(
                  leftWidget: Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SettingsContainer(
                  onPressed: () async {
                    await ref.read(solanaProvider.notifier).deauthorize();
                    await ref.read(authProvider.notifier).clearToken();
                    ref.invalidate(tabBarProvider);
                    ref.invalidate(scaffoldProvider);
                    ref.invalidate(myWalletProvider);
                    if (context.mounted) {
                      nextScreenCloseOthers(context, const WelcomeView());
                    }
                  },
                  leftWidget: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
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
                cacheManager: CacheManager(
                  Config(
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(64),
                border: Border.all(
                  color: ColorPalette.boxBackground400,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.add_a_photo_rounded,
                color: ColorPalette.dReaderYellow100.withOpacity(0.8),
                size: 64,
              ),
            ),
    );
  }
}
