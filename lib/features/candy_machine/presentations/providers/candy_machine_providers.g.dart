// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candy_machine_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$candyMachineHash() => r'e4d5dd23ef8e66c169facf8a85e505e5f9b6b253';

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

/// See also [candyMachine].
@ProviderFor(candyMachine)
const candyMachineProvider = CandyMachineFamily();

/// See also [candyMachine].
class CandyMachineFamily extends Family<AsyncValue<CandyMachineModel?>> {
  /// See also [candyMachine].
  const CandyMachineFamily();

  /// See also [candyMachine].
  CandyMachineProvider call({
    required String query,
  }) {
    return CandyMachineProvider(
      query: query,
    );
  }

  @override
  CandyMachineProvider getProviderOverride(
    covariant CandyMachineProvider provider,
  ) {
    return call(
      query: provider.query,
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
  String? get name => r'candyMachineProvider';
}

/// See also [candyMachine].
class CandyMachineProvider
    extends AutoDisposeFutureProvider<CandyMachineModel?> {
  /// See also [candyMachine].
  CandyMachineProvider({
    required String query,
  }) : this._internal(
          (ref) => candyMachine(
            ref as CandyMachineRef,
            query: query,
          ),
          from: candyMachineProvider,
          name: r'candyMachineProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$candyMachineHash,
          dependencies: CandyMachineFamily._dependencies,
          allTransitiveDependencies:
              CandyMachineFamily._allTransitiveDependencies,
          query: query,
        );

  CandyMachineProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<CandyMachineModel?> Function(CandyMachineRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CandyMachineProvider._internal(
        (ref) => create(ref as CandyMachineRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<CandyMachineModel?> createElement() {
    return _CandyMachineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CandyMachineProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CandyMachineRef on AutoDisposeFutureProviderRef<CandyMachineModel?> {
  /// The parameter `query` of this provider.
  String get query;
}

class _CandyMachineProviderElement
    extends AutoDisposeFutureProviderElement<CandyMachineModel?>
    with CandyMachineRef {
  _CandyMachineProviderElement(super.provider);

  @override
  String get query => (origin as CandyMachineProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
