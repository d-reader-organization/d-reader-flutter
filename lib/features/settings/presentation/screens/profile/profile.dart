import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_reader_flutter/config/config.dart';
import 'package:d_reader_flutter/constants/constants.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/authentication/presentation/providers/auth_providers.dart';
import 'package:d_reader_flutter/features/settings/presentation/providers/profile_controller.dart';
import 'package:d_reader_flutter/features/user/domain/providers/user_provider.dart';
import 'package:d_reader_flutter/features/user/presentation/providers/user_providers.dart';
import 'package:d_reader_flutter/features/user/domain/models/user.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_notifier.dart';
import 'package:d_reader_flutter/shared/presentations/providers/global/global_providers.dart';
import 'package:d_reader_flutter/shared/theme/app_colors.dart';
import 'package:d_reader_flutter/shared/utils/dialog_triggers.dart';
import 'package:d_reader_flutter/shared/utils/screen_navigation.dart';
import 'package:d_reader_flutter/shared/utils/show_snackbar.dart';
import 'package:d_reader_flutter/shared/utils/validation.dart';
import 'package:d_reader_flutter/shared/widgets/buttons/custom_text_button.dart';
import 'package:d_reader_flutter/shared/widgets/textfields/text_field.dart';
import 'package:d_reader_flutter/features/settings/presentation/widgets/list_tile.dart';
import 'package:d_reader_flutter/features/settings/presentation/widgets/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileView extends HookConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(myUserProvider);
    return SettingsScaffold(
      appBarTitle: 'My Profile',
      bottomNavigationBar: SafeArea(
        child: Consumer(
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
                          final String username =
                              ref.read(usernameTextProvider);
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
                        isLoading: ref.watch(globalNotifierProvider).isLoading,
                        size: const Size(double.infinity, 40),
                        onPressed: () async {
                          if (provider.value != null) {
                            await ref
                                .read(profileControllerProvider.notifier)
                                .changeUsername(
                                  user: provider.value!,
                                  callback: (result) {
                                    showSnackBar(
                                      context: context,
                                      backgroundColor: result is String
                                          ? ColorPalette.dReaderRed
                                          : ColorPalette.dReaderGreen,
                                      text: result is String
                                          ? result
                                          : 'Your username has been updated.',
                                    );
                                  },
                                );
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
      ),
      body: provider.when(
        data: (user) {
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
                          fontSize: 14,
                          color: ColorPalette.greyscale100,
                        ),
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
                            onValidate: usernameValidation,
                            onChange: (String value) {
                              ref.read(usernameTextProvider.notifier).state =
                                  value;
                            },
                          ),
                          const Text(
                            usernameCriteriaText,
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
                  ref.read(environmentProvider).walletAuthTokenMap != null
                      ? SettingsCommonListTile(
                          title: 'Sync assets',
                          leadingPath:
                              '${Config.settingsAssetsPath}/light/wallet.svg',
                          overrideColor: Colors.green,
                          overrideLeading:
                              ref.watch(globalNotifierProvider).isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: ColorPalette.dReaderGreen,
                                      ),
                                    )
                                  : null,
                          overrideTrailing: const SizedBox(),
                          onTap: ref.watch(globalNotifierProvider).isLoading
                              ? null
                              : () {
                                  ref
                                      .read(profileControllerProvider.notifier)
                                      .syncUserWallets(
                                        userId: user.id,
                                        callback: () {
                                          showSnackBar(
                                            context: context,
                                            backgroundColor:
                                                ColorPalette.dReaderGreen,
                                            text: 'Assets synced successfully',
                                          );
                                        },
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
                        final result = await triggerConfirmationDialog(
                          context: context,
                          title: '',
                          subtitle: 'Are you sure you want logout?',
                        );
                        if (result) {
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
        await ref.read(profileControllerProvider.notifier).uploadAvatar(
              userId: user.id,
              callback: (result) {
                showSnackBar(
                  context: context,
                  text: result is String
                      ? result
                      : 'Your avatar has been uploaded.',
                  backgroundColor: ColorPalette.dReaderGreen,
                );
              },
            );
      },
      child: ref.watch(privateLoadingProvider)
          ? Center(
              child: Container(
                height: 96,
                width: 96,
                padding: const EdgeInsets.all(16),
                child: const CircularProgressIndicator(),
              ),
            )
          : user.avatar.isNotEmpty
              ? CircleAvatar(
                  radius: 48,
                  backgroundColor: ColorPalette.greyscale400,
                  backgroundImage: CachedNetworkImageProvider(
                    user.avatar,
                    maxHeight: 96,
                    maxWidth: 96,
                  ),
                )
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
