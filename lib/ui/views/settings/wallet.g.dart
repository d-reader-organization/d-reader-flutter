// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountInfoHash() => r'55bc7ead68aa7b6dc7f85aa6f2120f9658bfca3a';

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

typedef AccountInfoRef = AutoDisposeFutureProviderRef<AccountResult>;

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
    required this.address,
  }) : super.internal(
          (ref) => accountInfo(
            ref,
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
        );

  final String address;

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
