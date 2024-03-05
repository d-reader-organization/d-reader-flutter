import 'package:d_reader_flutter/features/authentication/presentation/screens/sign_in/sign_in.dart';
import 'package:d_reader_flutter/features/authentication/presentation/screens/sign_up/sign_up.dart';
import 'package:d_reader_flutter/features/nft/domain/models/nft.dart';
import 'package:d_reader_flutter/shared/domain/providers/environment/environment_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:d_reader_flutter/constants/routes.dart';
import 'package:d_reader_flutter/features/comic/domain/models/comic_model.dart';
import 'package:d_reader_flutter/ui/views/animations/mint_animation_screen.dart';
import 'package:d_reader_flutter/ui/views/animations/open_nft_animation_screen.dart';
import 'package:d_reader_flutter/ui/views/comic_details/comic_details.dart';
import 'package:d_reader_flutter/ui/views/comic_details/comic_info.dart';
import 'package:d_reader_flutter/ui/views/comic_issue_details.dart';
import 'package:d_reader_flutter/ui/views/creators/creator_details.dart';
import 'package:d_reader_flutter/ui/views/e_reader.dart';
import 'package:d_reader_flutter/ui/views/intro/initial.dart';
import 'package:d_reader_flutter/ui/views/intro/request_reset_password.dart';
import 'package:d_reader_flutter/ui/views/nft_details.dart';
import 'package:d_reader_flutter/ui/views/settings/about.dart';
import 'package:d_reader_flutter/ui/views/settings/change_network.dart';
import 'package:d_reader_flutter/ui/views/settings/profile/change_email.dart';
import 'package:d_reader_flutter/ui/views/settings/profile/change_password.dart';
import 'package:d_reader_flutter/ui/views/settings/profile/profile.dart';
import 'package:d_reader_flutter/ui/views/settings/profile/reset_password.dart';
import 'package:d_reader_flutter/ui/views/settings/referrals.dart';
import 'package:d_reader_flutter/ui/views/settings/wallet/my_wallets.dart';
import 'package:d_reader_flutter/ui/views/settings/wallet/wallet_info.dart';
import 'package:d_reader_flutter/ui/views/splash.dart';
import 'package:d_reader_flutter/ui/views/what_is_wallet.dart';
import 'package:d_reader_flutter/ui/widgets/app_update_wrapper.dart';
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
      ...homeRoutes,
    ],
  );
});

final router = GoRouter(
  initialLocation: RoutePath.home,
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
    ...homeRoutes,
  ],
);

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
];

final List<GoRoute> homeRoutes = [
  GoRoute(
    path: RoutePath.home,
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
          return ComicIssueDetails(id: int.parse(id));
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
        path: '${RoutePath.nftDetails}/:address',
        builder: (context, state) {
          final address = state.pathParameters['address'] ?? '';
          return NftDetails(address: address);
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
    ],
  ),
];

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
      final nft = state.extra as NftModel;
      return DoneMintingAnimation(nft: nft);
    },
  ),
  GoRoute(
    path: RoutePath.openNftAnimation,
    builder: (context, state) {
      return const OpenNftAnimation();
    },
  ),
  GoRoute(
    path: RoutePath.mintLoadingAnimation,
    builder: (context, state) {
      return const MintLoadingAnimation();
    },
  ),
];
