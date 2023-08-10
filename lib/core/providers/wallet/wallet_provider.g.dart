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

typedef GetWalletRef = AutoDisposeFutureProviderRef<WalletModel?>;

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
    required this.address,
  }) : super.internal(
          (ref) => getWallet(
            ref,
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
        );

  final String address;

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
