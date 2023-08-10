// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'8a0d0670a6dee50232d59b4a47c2a64029ea3a5b';

/// See also [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = AutoDisposeProvider<UserRepositoryImpl>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserRepositoryRef = AutoDisposeProviderRef<UserRepositoryImpl>;
String _$myUserHash() => r'dcce5ba0c551bc148791914a301b1ef5f6f25323';

/// See also [myUser].
@ProviderFor(myUser)
final myUserProvider = AutoDisposeFutureProvider<UserModel?>.internal(
  myUser,
  name: r'myUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MyUserRef = AutoDisposeFutureProviderRef<UserModel?>;
String _$resetPasswordHash() => r'f20a47dc7a505ed5f152a27c2d21ed3fabd280dc';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef ResetPasswordRef = AutoDisposeFutureProviderRef<void>;

/// See also [resetPassword].
@ProviderFor(resetPassword)
const resetPasswordProvider = ResetPasswordFamily();

/// See also [resetPassword].
class ResetPasswordFamily extends Family<AsyncValue<void>> {
  /// See also [resetPassword].
  const ResetPasswordFamily();

  /// See also [resetPassword].
  ResetPasswordProvider call({
    required String id,
  }) {
    return ResetPasswordProvider(
      id: id,
    );
  }

  @override
  ResetPasswordProvider getProviderOverride(
    covariant ResetPasswordProvider provider,
  ) {
    return call(
      id: provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'resetPasswordProvider';
}

/// See also [resetPassword].
class ResetPasswordProvider extends AutoDisposeFutureProvider<void> {
  /// See also [resetPassword].
  ResetPasswordProvider({
    required this.id,
  }) : super.internal(
          (ref) => resetPassword(
            ref,
            id: id,
          ),
          from: resetPasswordProvider,
          name: r'resetPasswordProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$resetPasswordHash,
          dependencies: ResetPasswordFamily._dependencies,
          allTransitiveDependencies:
              ResetPasswordFamily._allTransitiveDependencies,
        );

  final String id;

  @override
  bool operator ==(Object other) {
    return other is ResetPasswordProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$requestEmailVerificationHash() =>
    r'08c61e6ada0b3a731d6fe0b69e0302cfab4f1ecd';

/// See also [requestEmailVerification].
@ProviderFor(requestEmailVerification)
final requestEmailVerificationProvider =
    AutoDisposeFutureProvider<void>.internal(
  requestEmailVerification,
  name: r'requestEmailVerificationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$requestEmailVerificationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RequestEmailVerificationRef = AutoDisposeFutureProviderRef<void>;
String _$verifyEmailHash() => r'828b08f9c3ededb19ec72cc08e055402792c6e98';
typedef VerifyEmailRef = AutoDisposeFutureProviderRef<void>;

/// See also [verifyEmail].
@ProviderFor(verifyEmail)
const verifyEmailProvider = VerifyEmailFamily();

/// See also [verifyEmail].
class VerifyEmailFamily extends Family<AsyncValue<void>> {
  /// See also [verifyEmail].
  const VerifyEmailFamily();

  /// See also [verifyEmail].
  VerifyEmailProvider call({
    required String verificationToken,
  }) {
    return VerifyEmailProvider(
      verificationToken: verificationToken,
    );
  }

  @override
  VerifyEmailProvider getProviderOverride(
    covariant VerifyEmailProvider provider,
  ) {
    return call(
      verificationToken: provider.verificationToken,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'verifyEmailProvider';
}

/// See also [verifyEmail].
class VerifyEmailProvider extends AutoDisposeFutureProvider<void> {
  /// See also [verifyEmail].
  VerifyEmailProvider({
    required this.verificationToken,
  }) : super.internal(
          (ref) => verifyEmail(
            ref,
            verificationToken: verificationToken,
          ),
          from: verifyEmailProvider,
          name: r'verifyEmailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$verifyEmailHash,
          dependencies: VerifyEmailFamily._dependencies,
          allTransitiveDependencies:
              VerifyEmailFamily._allTransitiveDependencies,
        );

  final String verificationToken;

  @override
  bool operator ==(Object other) {
    return other is VerifyEmailProvider &&
        other.verificationToken == verificationToken;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, verificationToken.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
