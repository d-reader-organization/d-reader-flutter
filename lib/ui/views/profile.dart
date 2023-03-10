import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/core/models/wallet.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/wallet_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/format_address.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/rounded_button.dart';
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
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AvatarName(
                  wallet: wallet!,
                  ref: ref,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                ),
                InputFieldWithSubmit(
                  wallet: wallet,
                  ref: ref,
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
                : Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: ColorPalette.boxBackground400, width: 2),
                    ),
                    child: Icon(
                      Icons.add_a_photo_rounded,
                      color: ColorPalette.dReaderYellow100.withOpacity(0.8),
                      size: 64,
                    ),
                  ),
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

class InputFieldWithSubmit extends StatefulWidget {
  final WalletModel wallet;
  final WidgetRef ref;
  const InputFieldWithSubmit({
    super.key,
    required this.wallet,
    required this.ref,
  });

  @override
  State<InputFieldWithSubmit> createState() => _InputFieldWithSubmitState();
}

class _InputFieldWithSubmitState extends State<InputFieldWithSubmit> {
  final TextEditingController _labelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _labelController.text = widget.wallet.label;
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  saveWallet() async {
    final notifier = widget.ref.read(globalStateProvider.notifier);
    notifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    await widget.ref.read(
      updateWalletProvider(
        UpdateWalletPayload(
          address: widget.wallet.address,
          label: _labelController.text,
        ),
      ).future,
    );
    notifier.update(
      (state) => state.copyWith(
        isLoading: false,
      ),
    );
    widget.ref.invalidate(myWalletProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your wallet has been uploaded.'),
          duration: Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _labelController,
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
            labelText: 'Label',
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        ValueListenableBuilder(
          valueListenable: _labelController,
          builder: (context, value, child) {
            return RoundedButton(
              text: 'Save',
              size: Size(MediaQuery.of(context).size.width / 2, 48),
              isLoading: widget.ref.watch(globalStateProvider).isLoading,
              onPressed: value.text.length > 2 ? saveWallet : null,
            );
          },
        ),
      ],
    );
  }
}
