// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getWalletHash() => r'20e7483ee73fe31fe7c7a83fa3f56569799f9e4f';

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

/// See also [getWallet].
@ProviderFor(getWallet)
const getWalletProvider = GetWalletFamily();

/// See also [getWallet].
class GetWalletFamily extends Family<AsyncValue<WalletModel?>> {
  /// See also [getWallet].
  const GetWalletFamily();

  /// See also [getWallet].
  GetWalletProvider call({
    required String address,
  }) {
    return GetWalletProvider(
      address: address,
    );
  }

  @override
  GetWalletProvider getProviderOverride(
    covariant GetWalletProvider provider,
  ) {
    return call(
      address: provider.address,
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
  String? get name => r'getWalletProvider';
}

/// See also [getWallet].
class GetWalletProvider extends AutoDisposeFutureProvider<WalletModel?> {
  /// See also [getWallet].
  GetWalletProvider({
    required String address,
  }) : this._internal(
          (ref) => getWallet(
            ref as GetWalletRef,
            address: address,
          ),
          from: getWalletProvider,
          name: r'getWalletProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getWalletHash,
          dependencies: GetWalletFamily._dependencies,
          allTransitiveDependencies: GetWalletFamily._allTransitiveDependencies,
          address: address,
        );

  GetWalletProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.address,
  }) : super.internal();

  final String address;

  @override
  Override overrideWith(
    FutureOr<WalletModel?> Function(GetWalletRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetWalletProvider._internal(
        (ref) => create(ref as GetWalletRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        address: address,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WalletModel?> createElement() {
    return _GetWalletProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetWalletProvider && other.address == address;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, address.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GetWalletRef on AutoDisposeFutureProviderRef<WalletModel?> {
  /// The parameter `address` of this provider.
  String get address;
}

class _GetWalletProviderElement
    extends AutoDisposeFutureProviderElement<WalletModel?> with GetWalletRef {
  _GetWalletProviderElement(super.provider);

  @override
  String get address => (origin as GetWalletProvider).address;
}

String _$accountInfoHash() => r'55bc7ead68aa7b6dc7f85aa6f2120f9658bfca3a';

/// See also [accountInfo].
@ProviderFor(accountInfo)
const accountInfoProvider = AccountInfoFamily();

/// See also [accountInfo].
class AccountInfoFamily extends Family<AsyncValue<AccountResult>> {
  /// See also [accountInfo].
  const AccountInfoFamily();

  /// See also [accountInfo].
  AccountInfoProvider call({
    required String address,
  }) {
    return AccountInfoProvider(
      address: address,
    );
  }

  @override
  AccountInfoProvider getProviderOverride(
    covariant AccountInfoProvider provider,
  ) {
    return call(
      address: provider.address,
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
  String? get name => r'accountInfoProvider';
}

/// See also [accountInfo].
class AccountInfoProvider extends AutoDisposeFutureProvider<AccountResult> {
  /// See also [accountInfo].
  AccountInfoProvider({
    required String address,
  }) : this._internal(
          (ref) => accountInfo(
            ref as AccountInfoRef,
            address: address,
          ),
          from: accountInfoProvider,
          name: r'accountInfoProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountInfoHash,
          dependencies: AccountInfoFamily._dependencies,
          allTransitiveDependencies:
              AccountInfoFamily._allTransitiveDependencies,
          address: address,
        );

  AccountInfoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.address,
  }) : super.internal();

  final String address;

  @override
  Override overrideWith(
    FutureOr<AccountResult> Function(AccountInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountInfoProvider._internal(
        (ref) => create(ref as AccountInfoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        address: address,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AccountResult> createElement() {
    return _AccountInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountInfoProvider && other.address == address;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, address.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountInfoRef on AutoDisposeFutureProviderRef<AccountResult> {
  /// The parameter `address` of this provider.
  String get address;
}

class _AccountInfoProviderElement
    extends AutoDisposeFutureProviderElement<AccountResult>
    with AccountInfoRef {
  _AccountInfoProviderElement(super.provider);

  @override
  String get address => (origin as AccountInfoProvider).address;
}

String _$isWalletAvailableHash() => r'd02c7e296799e42f1b199d19c392377e9fa8653a';

/// See also [isWalletAvailable].
@ProviderFor(isWalletAvailable)
final isWalletAvailableProvider = AutoDisposeFutureProvider<bool>.internal(
  isWalletAvailable,
  name: r'isWalletAvailableProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isWalletAvailableHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsWalletAvailableRef = AutoDisposeFutureProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
