import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_address.dart';
import 'package:d_reader_flutter/ui/widgets/common/skeleton_row.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

class ProfileView extends ConsumerWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(myWalletProvider);

    return provider.when(
      data: (wallet) {
        return Container(
          margin: const EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AvatarName(
                wallet: wallet!,
                ref: ref,
              ),
              TextField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorPalette.dReaderYellow100,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorPalette.dReaderYellow100,
                    ),
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2,
                  ),
                  contentPadding: const EdgeInsets.all(8),
                  labelText: '${wallet.label} label',
                  labelStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(),
              const SizedBox(),
            ],
          ),
        );
      },
      error: (Object error, StackTrace stackTrace) {
        print('Error in profile view ${error.toString()}');
        return const Text('Something went wrong');
      },
      loading: () {
        return const WalletSkeleton();
      },
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
        SkeletonRow(),
        SkeletonRow(),
      ],
    );
  }
}

class AvatarName extends StatelessWidget {
  final WalletModel wallet;
  final WidgetRef ref;
  const AvatarName({
    super.key,
    required this.wallet,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles();
            if (result != null) {
              File file = File(result.files.single.path ?? '');
              final bytes = await file.readAsBytes();
              await ref.read(
                updateWalletAvatarProvider(
                  UpdateAvatarPayload(
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
          child: CircleAvatar(
            radius: 64,
            backgroundColor: Colors.transparent,
            child: wallet.avatar.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: wallet.avatar,
                    cacheKey: wallet.avatar,
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(64),
                          image: DecorationImage(
                            image: imageProvider,
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox(),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(formatAddress(wallet.address)),
      ],
    );
  }
}
