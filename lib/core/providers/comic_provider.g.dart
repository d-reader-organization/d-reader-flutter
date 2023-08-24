// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ownedComicsHash() => r'fad02d198be5b3ba44669d681f757d72ba849338';

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

typedef OwnedComicsRef = AutoDisposeFutureProviderRef<List<ComicModel>>;

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
    required this.userId,
    required this.query,
  }) : super.internal(
          (ref) => ownedComics(
            ref,
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
        );

  final int userId;
  final String query;

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
