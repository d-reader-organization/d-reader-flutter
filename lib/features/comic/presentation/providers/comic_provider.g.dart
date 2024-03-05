// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ownedComicsHash() => r'cdc282f9f6133eed5566ff4700b9a2b2f8f062c0';

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

/// See also [ownedComics].
@ProviderFor(ownedComics)
const ownedComicsProvider = OwnedComicsFamily();

/// See also [ownedComics].
class OwnedComicsFamily extends Family<AsyncValue<List<ComicModel>>> {
  /// See also [ownedComics].
  const OwnedComicsFamily();

  /// See also [ownedComics].
  OwnedComicsProvider call({
    required int userId,
    required String query,
  }) {
    return OwnedComicsProvider(
      userId: userId,
      query: query,
    );
  }

  @override
  OwnedComicsProvider getProviderOverride(
    covariant OwnedComicsProvider provider,
  ) {
    return call(
      userId: provider.userId,
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
  String? get name => r'ownedComicsProvider';
}

/// See also [ownedComics].
class OwnedComicsProvider extends AutoDisposeFutureProvider<List<ComicModel>> {
  /// See also [ownedComics].
  OwnedComicsProvider({
    required int userId,
    required String query,
  }) : this._internal(
          (ref) => ownedComics(
            ref as OwnedComicsRef,
            userId: userId,
            query: query,
          ),
          from: ownedComicsProvider,
          name: r'ownedComicsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ownedComicsHash,
          dependencies: OwnedComicsFamily._dependencies,
          allTransitiveDependencies:
              OwnedComicsFamily._allTransitiveDependencies,
          userId: userId,
          query: query,
        );

  OwnedComicsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.query,
  }) : super.internal();

  final int userId;
  final String query;

  @override
  Override overrideWith(
    FutureOr<List<ComicModel>> Function(OwnedComicsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OwnedComicsProvider._internal(
        (ref) => create(ref as OwnedComicsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ComicModel>> createElement() {
    return _OwnedComicsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OwnedComicsProvider &&
        other.userId == userId &&
        other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin OwnedComicsRef on AutoDisposeFutureProviderRef<List<ComicModel>> {
  /// The parameter `userId` of this provider.
  int get userId;

  /// The parameter `query` of this provider.
  String get query;
}

class _OwnedComicsProviderElement
    extends AutoDisposeFutureProviderElement<List<ComicModel>>
    with OwnedComicsRef {
  _OwnedComicsProviderElement(super.provider);

  @override
  int get userId => (origin as OwnedComicsProvider).userId;
  @override
  String get query => (origin as OwnedComicsProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
