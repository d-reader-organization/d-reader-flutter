// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$myUserHash() => r'244957fd48ad93d0600fb20c0622ef8f90db1723';

/// See also [myUser].
@ProviderFor(myUser)
final myUserProvider = AutoDisposeFutureProvider<UserModel>.internal(
  myUser,
  name: r'myUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MyUserRef = AutoDisposeFutureProviderRef<UserModel>;
String _$userWalletsHash() => r'aa3ca9c5e83e2e1e56ae8111b3384a13d33a4eab';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
