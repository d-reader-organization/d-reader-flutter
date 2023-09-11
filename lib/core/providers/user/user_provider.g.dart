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
    required String id,
  }) : this._internal(
          (ref) => resetPassword(
            ref as ResetPasswordRef,
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
          id: id,
        );

  ResetPasswordProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<void> Function(ResetPasswordRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ResetPasswordProvider._internal(
        (ref) => create(ref as ResetPasswordRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _ResetPasswordProviderElement(this);
  }

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

mixin ResetPasswordRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ResetPasswordProviderElement
    extends AutoDisposeFutureProviderElement<void> with ResetPasswordRef {
  _ResetPasswordProviderElement(super.provider);

  @override
  String get id => (origin as ResetPasswordProvider).id;
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
String _$userWalletsHash() => r'1afcfc64ff6df8b289f0a0a18454116d3dcbe018';

/// See also [userWallets].
@ProviderFor(userWallets)
const userWalletsProvider = UserWalletsFamily();

/// See also [userWallets].
class UserWalletsFamily extends Family<AsyncValue<List<WalletModel>>> {
  /// See also [userWallets].
  const UserWalletsFamily();

  /// See also [userWallets].
  UserWalletsProvider call({
    required int? id,
  }) {
    return UserWalletsProvider(
      id: id,
    );
  }

  @override
  UserWalletsProvider getProviderOverride(
    covariant UserWalletsProvider provider,
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
  String? get name => r'userWalletsProvider';
}

/// See also [userWallets].
class UserWalletsProvider extends AutoDisposeFutureProvider<List<WalletModel>> {
  /// See also [userWallets].
  UserWalletsProvider({
    required int? id,
  }) : this._internal(
          (ref) => userWallets(
            ref as UserWalletsRef,
            id: id,
          ),
          from: userWalletsProvider,
          name: r'userWalletsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userWalletsHash,
          dependencies: UserWalletsFamily._dependencies,
          allTransitiveDependencies:
              UserWalletsFamily._allTransitiveDependencies,
          id: id,
        );

  UserWalletsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int? id;

  @override
  Override overrideWith(
    FutureOr<List<WalletModel>> Function(UserWalletsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserWalletsProvider._internal(
        (ref) => create(ref as UserWalletsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WalletModel>> createElement() {
    return _UserWalletsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserWalletsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserWalletsRef on AutoDisposeFutureProviderRef<List<WalletModel>> {
  /// The parameter `id` of this provider.
  int? get id;
}

class _UserWalletsProviderElement
    extends AutoDisposeFutureProviderElement<List<WalletModel>>
    with UserWalletsRef {
  _UserWalletsProviderElement(super.provider);

  @override
  int? get id => (origin as UserWalletsProvider).id;
}

String _$userAssetsHash() => r'cb93a6f28c294d1404ee38b6c18c6ad0b56ea7bf';

/// See also [userAssets].
@ProviderFor(userAssets)
const userAssetsProvider = UserAssetsFamily();

/// See also [userAssets].
class UserAssetsFamily extends Family<AsyncValue<List<WalletAsset>>> {
  /// See also [userAssets].
  const UserAssetsFamily();

  /// See also [userAssets].
  UserAssetsProvider call({
    required int id,
  }) {
    return UserAssetsProvider(
      id: id,
    );
  }

  @override
  UserAssetsProvider getProviderOverride(
    covariant UserAssetsProvider provider,
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
  String? get name => r'userAssetsProvider';
}

/// See also [userAssets].
class UserAssetsProvider extends AutoDisposeFutureProvider<List<WalletAsset>> {
  /// See also [userAssets].
  UserAssetsProvider({
    required int id,
  }) : this._internal(
          (ref) => userAssets(
            ref as UserAssetsRef,
            id: id,
          ),
          from: userAssetsProvider,
          name: r'userAssetsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userAssetsHash,
          dependencies: UserAssetsFamily._dependencies,
          allTransitiveDependencies:
              UserAssetsFamily._allTransitiveDependencies,
          id: id,
        );

  UserAssetsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<List<WalletAsset>> Function(UserAssetsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserAssetsProvider._internal(
        (ref) => create(ref as UserAssetsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WalletAsset>> createElement() {
    return _UserAssetsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserAssetsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UserAssetsRef on AutoDisposeFutureProviderRef<List<WalletAsset>> {
  /// The parameter `id` of this provider.
  int get id;
}

class _UserAssetsProviderElement
    extends AutoDisposeFutureProviderElement<List<WalletAsset>>
    with UserAssetsRef {
  _UserAssetsProviderElement(super.provider);

  @override
  int get id => (origin as UserAssetsProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
