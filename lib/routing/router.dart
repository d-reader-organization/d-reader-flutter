import 'package:d_reader_flutter/features/authentication/presentation/screens/sign_in/sign_in.dart';
import 'package:d_reader_flutter/features/authentication/presentation/screens/sign_up/sign_up.dart';
import 'package:d_reader_flutter/features/authentication/presentation/screens/verify_email.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/screens/comic_issue_cover.dart';
import 'package:d_reader_flutter/features/library/presentation/providers/owned/owned_providers.dart';
import 'package:d_reader_flutter/features/digital_asset/domain/models/digital_asset.dart';
import 'package:d_reader_flutter/features/settings/presentation/screens/security_and_privacy.dart';
import 'package:d_reader_flutter/features/transaction/presentation/screens/transaction_timeout.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/screens/animations/mint_animation_screen.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/screens/animations/open_asset_animation_screen.dart';
import 'package:d_reader_flutter/features/comic/presentation/screens/comic_details.dart';
import 'package:d_reader_flutter/features/comic/presentation/screens/comic_info.dart';
import 'package:d_reader_flutter/features/comic_issue/presentation/screens/comic_issue_details.dart';
import 'package:d_reader_flutter/features/creator/presentation/screens/creator_details.dart';
import 'package:d_reader_flutter/features/e_reader/presentation/screens/e_reader.dart';
import 'package:d_reader_flutter/features/home/presentation/screens/initial.dart';
import 'package:d_reader_flutter/features/authentication/presentation/screens/request_reset_password.dart';
import 'package:d_reader_flutter/features/digital_asset/presentation/screens/digital_asset_details.dart';
import 'package:d_reader_flutter/features/settings/presentation/screens/about.dart';
import 'package:d_reader_flutter/features/settings/presentation/screens/change_network.dart';
import 'package:d_reader_flutter/features/settings/presentation/screens/profile/change_email.dart';
import 'package:d_reader_flutter/features/settings/presentation/screens/profile/change_password.dart';
import 'package:d_reader_flutter/features/settings/presentation/screens/profile/profile.dart';
import 'package:d_reader_flutter/features/settings/presentation/screens/profile/reset_password.dart';
import 'package:d_reader_flutter/features/settings/presentation/screens/referrals.dart';
import 'package:d_reader_flutter/features/settings/presentation/screens/wallet/my_wallets.dart';
import 'package:d_reader_flutter/features/settings/presentation/screens/wallet/wallet_info.dart';
import 'package:d_reader_flutter/features/home/presentation/screens/splash.dart';
import 'package:d_reader_flutter/features/wallet/presentation/screens/what_is_wallet.dart';
import 'package:d_reader_flutter/shared/widgets/wrappers/app_update_wrapper.dart';
import 'package:go_router/go_router.dart';

final routerNavigatorKey = GlobalKey<NavigatorState>();

class AuthNotifier extends ChangeNotifier {
  bool isLoggedIn = false;

  AuthNotifier({
    required this.isLoggedIn,
  });

  void login() {
    isLoggedIn = true;
  }

  void logout() {
    isLoggedIn = false;
  }
}

final authRouteProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  final isLoggedIn = ref.read(environmentProvider).jwtToken != null;
  return AuthNotifier(isLoggedIn: isLoggedIn);
});

final unauthorizedRoutes = [
  RoutePath.welcome,
  RoutePath.initial,
  RoutePath.signIn,
  RoutePath.signUp,
  RoutePath.requestRessetPassword,
];

final routerProvider = Provider((ref) {
  final authState = ref.watch(authRouteProvider);
  return GoRouter(
    initialLocation: RoutePath.home,
    navigatorKey: routerNavigatorKey,
    refreshListenable: authState,
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      if (state.fullPath == RoutePath.signIn) {
        return isLoggedIn ? null : RoutePath.signIn;
      }
      if (isLoggedIn || unauthorizedRoutes.contains(state.matchedLocation)) {
        return state.uri.toString();
      }
      return RoutePath.welcome;
    },
    routes: [
      GoRoute(
        path: RoutePath.welcome,
        builder: (context, state) {
          return const SplashView();
        },
      ),
      GoRoute(
        path: RoutePath.initial,
        builder: (context, state) {
          return const InitialIntroScreen();
        },
      ),
      ...authRoutes,
      ...generateHomeRoutes(ref),
    ],
  );
});

final List<GoRoute> authRoutes = [
  GoRoute(
    path: RoutePath.signIn,
    builder: (context, state) {
      return const SignInScreen();
    },
  ),
  GoRoute(
    path: RoutePath.signUp,
    builder: (context, state) {
      return const SignUpScreen();
    },
  ),
  GoRoute(
    path: RoutePath.requestRessetPassword,
    builder: (context, state) {
      return const RequestResetPasswordView();
    },
  ),
  GoRoute(
    path: '${RoutePath.verifyEmail}/:verificationId',
    builder: (context, state) {
      final verificationId = state.pathParameters['verificationId'] ?? '';
      return VerifyEmailScreen(verificationId: verificationId);
    },
  ),
];

List<GoRoute> generateHomeRoutes(ProviderRef ref) {
  return [
    GoRoute(
      path: RoutePath.home,
      onExit: (context, state) async {
        if (ref.read(selectedIssueInfoProvider) != null) {
          ref.invalidate(selectedIssueInfoProvider);
          return false;
        }
        if (ref.read(selectedOwnedComicProvider) != null) {
          ref.invalidate(selectedOwnedComicProvider);
          return false;
        }

        return true;
      },
      builder: (context, state) {
        return const AppUpdateWrapper();
      },
      routes: [
        ...comicRoutes,
        ...profileRoutes,
        ...animationRoutes,
        GoRoute(
          path: '${RoutePath.comicIssueDetails}/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return ComicIssueDetails(id: id);
          },
        ),
        GoRoute(
          path: 'mint/:id',
          redirect: (context, state) =>
              '/${RoutePath.comicIssueDetails}/${state.pathParameters['id']}',
        ),
        GoRoute(
          path: RoutePath.comicIssueCover,
          builder: (context, state) {
            final String imageUrl = state.extra as String;
            return ComicIssueCoverScreen(imageUrl: imageUrl);
          },
        ),
        GoRoute(
          path: '${RoutePath.creatorDetails}/:slug',
          builder: (context, state) {
            final slug = state.pathParameters['slug'] ?? '';
            return CreatorDetailsView(slug: slug);
          },
        ),
        GoRoute(
          path: '${RoutePath.digitalAssetDetails}/:address',
          builder: (context, state) {
            final address = state.pathParameters['address'] ?? '';
            return DigitalAssetDetails(address: address);
          },
        ),
        GoRoute(
          path: '${RoutePath.eReader}/:comicIssueId',
          builder: (context, state) {
            final comicIssueId = state.pathParameters['comicIssueId'] ?? '';
            return EReaderView(
              issueId: int.parse(
                comicIssueId,
              ),
            );
          },
        ),
        GoRoute(
          path: '${RoutePath.myWallets}/:userId',
          builder: (context, state) {
            final userId = state.pathParameters['userId'] ?? '';
            return MyWalletsScreen(userId: int.parse(userId));
          },
        ),
        GoRoute(
          path: RoutePath.referrals,
          builder: (context, state) {
            return const ReferralsView();
          },
        ),
        GoRoute(
          path: RoutePath.about,
          builder: (context, state) {
            return const AboutView();
          },
        ),
        GoRoute(
          path: RoutePath.changeNetwork,
          builder: (context, state) {
            return const ChangeNetworkView();
          },
        ),
        GoRoute(
          path: RoutePath.walletInfo,
          builder: (context, state) {
            final address = state.uri.queryParameters['address'] ?? '';
            final name = state.uri.queryParameters['name'] ?? '';
            return WalletInfoScreen(address: address, name: name);
          },
        ),
        GoRoute(
          path: RoutePath.whatIsAWallet,
          builder: (context, state) {
            return const WhatIsWalletView();
          },
        ),
        GoRoute(
          path: RoutePath.securityAndPrivacy,
          builder: (context, state) {
            return const SecurityAndPrivacyScreen();
          },
        ),
        GoRoute(
          path: RoutePath.transactionStatusTimeout,
          builder: (context, state) {
            return const TransactionTimeoutScreen();
          },
        ),
      ],
    ),
  ];
}

final List<GoRoute> comicRoutes = [
  GoRoute(
    path: '${RoutePath.comicDetails}/:slug',
    builder: (context, state) {
      final slug = state.pathParameters['slug'] ?? '';
      return ComicDetails(slug: slug);
    },
  ),
  GoRoute(
    path: RoutePath.comicDetailsInfo,
    builder: (context, state) {
      final comic = state.extra as ComicModel;
      return ComicInfoView(comic: comic);
    },
  )
];

final List<GoRoute> profileRoutes = [
  GoRoute(
    path: RoutePath.profile,
    builder: (context, state) {
      return const ProfileView();
    },
  ),
  GoRoute(
    path: RoutePath.changeEmail,
    builder: (context, state) {
      return const ChangeEmailView();
    },
  ),
  GoRoute(
    path: RoutePath.changePassword,
    builder: (context, state) {
      final userId = state.uri.queryParameters['userId'] ?? '';
      final email = state.uri.queryParameters['email'] ?? '';
      return ChangePasswordView(userId: int.parse(userId), email: email);
    },
  ),
  GoRoute(
    path: RoutePath.resetPassword,
    builder: (context, state) {
      final userId = state.uri.queryParameters['userId'] ?? '';
      final email = state.uri.queryParameters['email'] ?? '';
      return ResetPasswordView(id: userId, email: email);
    },
  ),
];

final List<GoRoute> animationRoutes = [
  GoRoute(
    path: RoutePath.doneMinting,
    builder: (context, state) {
      final digitalAsset = state.extra as DigitalAssetModel;
      return DoneMintingAnimation(digitalAsset: digitalAsset);
    },
  ),
  GoRoute(
    path: RoutePath.openDigitalAssetAnimation,
    builder: (context, state) {
      return const OpenDigitalAssetAnimation();
    },
  ),
  GoRoute(
    path: RoutePath.mintLoadingAnimation,
    builder: (context, state) {
      return const MintLoadingAnimation();
    },
  ),
];
