// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unwrap_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unwrapNotifierHash() => r'62e98b1f41adc4773fbae49b7c8575ccac239d61';

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

abstract class _$UnwrapNotifier
    extends BuildlessAutoDisposeNotifier<TransactionState> {
  late final String? address;

  TransactionState build([
    String? address,
  ]);
}

/// See also [UnwrapNotifier].
@ProviderFor(UnwrapNotifier)
const unwrapNotifierProvider = UnwrapNotifierFamily();

/// See also [UnwrapNotifier].
class UnwrapNotifierFamily extends Family<TransactionState> {
  /// See also [UnwrapNotifier].
  const UnwrapNotifierFamily();

  /// See also [UnwrapNotifier].
  UnwrapNotifierProvider call([
    String? address,
  ]) {
    return UnwrapNotifierProvider(
      address,
    );
  }

  @override
  UnwrapNotifierProvider getProviderOverride(
    covariant UnwrapNotifierProvider provider,
  ) {
    return call(
      provider.address,
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
  String? get name => r'unwrapNotifierProvider';
}

/// See also [UnwrapNotifier].
class UnwrapNotifierProvider
    extends AutoDisposeNotifierProviderImpl<UnwrapNotifier, TransactionState> {
  /// See also [UnwrapNotifier].
  UnwrapNotifierProvider([
    String? address,
  ]) : this._internal(
          () => UnwrapNotifier()..address = address,
          from: unwrapNotifierProvider,
          name: r'unwrapNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$unwrapNotifierHash,
          dependencies: UnwrapNotifierFamily._dependencies,
          allTransitiveDependencies:
              UnwrapNotifierFamily._allTransitiveDependencies,
          address: address,
        );

  UnwrapNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.address,
  }) : super.internal();

  final String? address;

  @override
  TransactionState runNotifierBuild(
    covariant UnwrapNotifier notifier,
  ) {
    return notifier.build(
      address,
    );
  }

  @override
  Override overrideWith(UnwrapNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: UnwrapNotifierProvider._internal(
        () => create()..address = address,
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
  AutoDisposeNotifierProviderElement<UnwrapNotifier, TransactionState>
      createElement() {
    return _UnwrapNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UnwrapNotifierProvider && other.address == address;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, address.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin UnwrapNotifierRef on AutoDisposeNotifierProviderRef<TransactionState> {
  /// The parameter `address` of this provider.
  String? get address;
}

class _UnwrapNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<UnwrapNotifier, TransactionState>
    with UnwrapNotifierRef {
  _UnwrapNotifierProviderElement(super.provider);

  @override
  String? get address => (origin as UnwrapNotifierProvider).address;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
