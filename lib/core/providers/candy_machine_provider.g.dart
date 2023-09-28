// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'candy_machine_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$candyMachineGroupsHash() =>
    r'33a3aa82e67db082c9e949810f6db2a4ac4f5d23';

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

/// See also [candyMachineGroups].
@ProviderFor(candyMachineGroups)
const candyMachineGroupsProvider = CandyMachineGroupsFamily();

/// See also [candyMachineGroups].
class CandyMachineGroupsFamily
    extends Family<AsyncValue<List<CandyMachineGroupModel>>> {
  /// See also [candyMachineGroups].
  const CandyMachineGroupsFamily();

  /// See also [candyMachineGroups].
  CandyMachineGroupsProvider call({
    required String query,
  }) {
    return CandyMachineGroupsProvider(
      query: query,
    );
  }

  @override
  CandyMachineGroupsProvider getProviderOverride(
    covariant CandyMachineGroupsProvider provider,
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
  String? get name => r'candyMachineGroupsProvider';
}

/// See also [candyMachineGroups].
class CandyMachineGroupsProvider
    extends AutoDisposeFutureProvider<List<CandyMachineGroupModel>> {
  /// See also [candyMachineGroups].
  CandyMachineGroupsProvider({
    required String query,
  }) : this._internal(
          (ref) => candyMachineGroups(
            ref as CandyMachineGroupsRef,
            query: query,
          ),
          from: candyMachineGroupsProvider,
          name: r'candyMachineGroupsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$candyMachineGroupsHash,
          dependencies: CandyMachineGroupsFamily._dependencies,
          allTransitiveDependencies:
              CandyMachineGroupsFamily._allTransitiveDependencies,
          query: query,
        );

  CandyMachineGroupsProvider._internal(
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
    FutureOr<List<CandyMachineGroupModel>> Function(
            CandyMachineGroupsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CandyMachineGroupsProvider._internal(
        (ref) => create(ref as CandyMachineGroupsRef),
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
  AutoDisposeFutureProviderElement<List<CandyMachineGroupModel>>
      createElement() {
    return _CandyMachineGroupsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CandyMachineGroupsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CandyMachineGroupsRef
    on AutoDisposeFutureProviderRef<List<CandyMachineGroupModel>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _CandyMachineGroupsProviderElement
    extends AutoDisposeFutureProviderElement<List<CandyMachineGroupModel>>
    with CandyMachineGroupsRef {
  _CandyMachineGroupsProviderElement(super.provider);

  @override
  String get query => (origin as CandyMachineGroupsProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
