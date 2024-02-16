import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/core/models/user.dart';
import 'package:d_reader_flutter/core/notifiers/environment_notifier.dart';
import 'package:d_reader_flutter/core/providers/global_provider.dart';
import 'package:d_reader_flutter/core/providers/logout_provider.dart';
import 'package:d_reader_flutter/core/providers/user/user_provider.dart';
import 'package:d_reader_flutter/ui/shared/app_colors.dart';
import 'package:d_reader_flutter/ui/utils/screen_navigation.dart';
import 'package:d_reader_flutter/ui/utils/show_snackbar.dart';
import 'package:d_reader_flutter/ui/utils/username_validator.dart';
import 'package:d_reader_flutter/ui/widgets/common/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/ui/widgets/common/text_field.dart';
import 'package:d_reader_flutter/ui/widgets/settings/list_tile.dart';
import 'package:d_reader_flutter/ui/widgets/settings/scaffold.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

  syncWallets({
    required BuildContext context,
    required WidgetRef ref,
    required int userId,
  }) async {
    final globalNotifier = ref.read(globalStateProvider.notifier);

    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: true,
      ),
    );
    await ref.read(userRepositoryProvider).syncWallets(userId);
    globalNotifier.update(
      (state) => state.copyWith(
        isLoading: false,
      ),
    );

    if (context.mounted) {
      displaySnackBar(
        context: context,
        color: ColorPalette.dReaderGreen,
        text: 'Assets synced successfully',
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(myUserProvider);
    return SettingsScaffold(
      appBarTitle: 'My Profile',
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final String username = ref.watch(usernameTextProvider);
          return AnimatedOpacity(
            opacity:
                username.isNotEmpty && username.trim() != provider.value?.name
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
                        final String username = ref.read(usernameTextProvider);
                        if (username.isNotEmpty) {
                          ref.read(usernameTextProvider.notifier).state = '';
                        }
                        context.pop();
                      },
                      borderRadius: BorderRadius.circular(8),
                      backgroundColor: Colors.transparent,
                      textColor: ColorPalette.greyscale50,
                      borderColor: ColorPalette.greyscale50,
                      child: const Text('Cancel'),
                    ),
                  ),
                  Expanded(
                    child: CustomTextButton(
                      isLoading: ref.watch(globalStateProvider).isLoading,
                      size: const Size(double.infinity, 40),
                      onPressed: () async {
                        final String username = ref.read(usernameTextProvider);
                        if (username.isNotEmpty) {
                          final notifier =
                              ref.read(globalStateProvider.notifier);

                          if (provider.value?.id != null) {
                            notifier.update(
                              (state) => state.copyWith(
                                isLoading: true,
                              ),
                            );
                            final updateResult = await ref
                                .read(userRepositoryProvider)
                                .updateUser(
                                  UpdateUserPayload(
                                    id: provider.value!.id,
                                    email: provider.value?.email ?? '',
                                    name: username,
                                  ),
                                );
                            notifier.update(
                              (state) => state.copyWith(
                                isLoading: false,
                              ),
                            );
                            ref
                                .read(usernameTextProvider.notifier)
                                .update((state) => '');
                            ref.invalidate(myUserProvider);
                            if (context.mounted) {
                              displaySnackBar(
                                context: context,
                                duration: const Duration(
                                  seconds: 2,
                                ),
                                color: updateResult is String
                                    ? ColorPalette.dReaderRed
                                    : ColorPalette.dReaderGreen,
                                text: updateResult is String
                                    ? updateResult
                                    : 'Your username has been updated.',
                              );
                            }
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
        data: (user) {
          if (user == null) {
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
                    user: user,
                    ref: ref,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      return Column(
                        children: [
                          CustomTextField(
                            labelText: 'Email',
                            hintText: user.email,
                            isReadOnly: true,
                          ),
                          CustomTextField(
                            labelText: 'Username',
                            defaultValue:
                                user.name.isNotEmpty ? user.name : null,
                            onValidate: (value) {
                              return validateUsername(value: value, ref: ref);
                            },
                            onChange: (String value) {
                              ref.read(usernameTextProvider.notifier).state =
                                  value;
                            },
                          ),
                          const Text(
                            'Must be 2 to 20 characters long. Letters, numbers and dashes are allowed.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: ColorPalette.greyscale200,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(
                    thickness: 1,
                    color: ColorPalette.greyscale500,
                  ),
                  !user.isEmailVerified
                      ? SettingsCommonListTile(
                          title: 'Send verification email',
                          leadingPath: 'assets/icons/reset_password.svg',
                          overrideColor: Colors.white,
                          overrideTrailing: const SizedBox(),
                          onTap: () async {
                            await ref
                                .read(userRepositoryProvider)
                                .requestEmailVerification();
                            if (context.mounted) {
                              showSnackBar(
                                context: context,
                                text: 'Verification email has been sent.',
                                backgroundColor: ColorPalette.dReaderGreen,
                              );
                            }
                          },
                        )
                      : SettingsCommonListTile(
                          title: 'Change email address',
                          leadingPath: 'assets/icons/reset_password.svg',
                          overrideColor: Colors.white,
                          overrideTrailing: const SizedBox(),
                          onTap: () {
                            nextScreenPush(
                              context: context,
                              path: RoutePath.changeEmail,
                            );
                          },
                        ),
                  SettingsCommonListTile(
                    title: 'Change password',
                    leadingPath: 'assets/icons/reset_password.svg',
                    overrideColor: Colors.white,
                    overrideTrailing: const SizedBox(),
                    onTap: () {
                      nextScreenPush(
                        context: context,
                        path:
                            '${RoutePath.changePassword}?userId=${user.id}&email=${user.email}',
                      );
                    },
                  ),
                  ref.read(environmentProvider).wallets != null
                      ? SettingsCommonListTile(
                          title: 'Sync assets',
                          leadingPath:
                              '${Config.settingsAssetsPath}/light/wallet.svg',
                          overrideColor: Colors.green,
                          overrideLeading:
                              ref.watch(globalStateProvider).isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: ColorPalette.dReaderGreen,
                                      ),
                                    )
                                  : null,
                          overrideTrailing: const SizedBox(),
                          onTap: ref.watch(globalStateProvider).isLoading
                              ? null
                              : () async {
                                  await syncWallets(
                                    context: context,
                                    ref: ref,
                                    userId: user.id,
                                  );
                                },
                        )
                      : const SizedBox(),
                  Container(
                    margin: const EdgeInsets.only(left: 2),
                    child: SettingsCommonListTile(
                      title: 'Log out',
                      leadingPath:
                          '${Config.settingsAssetsPath}/light/logout.svg',
                      overrideColor: ColorPalette.dReaderRed,
                      onTap: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: ColorPalette.greyscale400,
                              contentPadding: EdgeInsets.zero,
                              content: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 16,
                                    ),
                                    child: Text(
                                      'Are you sure you want to log out?',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            return context.pop(
                                              false,
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                right: BorderSide(
                                                  color:
                                                      ColorPalette.greyscale500,
                                                  width: 1,
                                                ),
                                                top: BorderSide(
                                                  color:
                                                      ColorPalette.greyscale500,
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                            child: const Text(
                                              'No',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            return context.pop(true);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color:
                                                      ColorPalette.greyscale500,
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                            child: const Text(
                                              'Yes',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        );
                        if (result != null && result) {
                          await ref.read(logoutProvider.future);
                          if (context.mounted) {
                            nextScreenCloseOthers(
                              context: context,
                              path: RoutePath.initial,
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (Object error, StackTrace stackTrace) {
          return const Text('Failed to fetch data');
        },
        loading: () {
          return const SizedBox();
        },
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final UserModel user;
  final WidgetRef ref;
  const Avatar({
    super.key,
    required this.user,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          File file = File(result.files.single.path ?? '');

          final notifier = ref.read(privateLoadingProvider.notifier);
          notifier.update(
            (state) => true,
          );
          final response = await ref.read(userRepositoryProvider).updateAvatar(
                UpdateUserPayload(
                  id: user.id,
                  avatar: file,
                ),
              );
          ref.invalidate(myUserProvider);
          Future.delayed(
            const Duration(milliseconds: 500),
            () {
              notifier.update((state) => false);
            },
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  response is String
                      ? response
                      : 'Your avatar has been uploaded.',
                ),
                duration: const Duration(milliseconds: 500),
                backgroundColor: ColorPalette.dReaderGreen,
              ),
            );
          }
        }
      },
      child: ref.watch(privateLoadingProvider)
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
          : user.avatar.isNotEmpty
              ? CircleAvatar(
                  radius: 48,
                  backgroundColor: ColorPalette.greyscale400,
                  child: CachedNetworkImage(
                    key: ValueKey(user.avatar),
                    imageUrl: user.avatar,
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
                  padding: const EdgeInsets.all(8),
                  height: 96,
                  width: 96,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(64),
                    border: Border.all(
                      color: ColorPalette.greyscale300,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
