// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comics_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$genericComicNotifierHash() =>
    r'9f19236bff9d303cd1ca4a877a57bd0bf479e8f1';

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

abstract class _$GenericComicNotifier
    extends BuildlessAutoDisposeAsyncNotifier<List<ComicModel>> {
  late final int userId;
  late final Future<Either<AppException, List<ComicModel>>> Function(
      {required String query, required int userId}) fetch;

  FutureOr<List<ComicModel>> build({
    required int userId,
    required Future<Either<AppException, List<ComicModel>>> Function(
            {required String query, required int userId})
        fetch,
  });
}

/// See also [GenericComicNotifier].
@ProviderFor(GenericComicNotifier)
const genericComicNotifierProvider = GenericComicNotifierFamily();

/// See also [GenericComicNotifier].
class GenericComicNotifierFamily extends Family<AsyncValue<List<ComicModel>>> {
  /// See also [GenericComicNotifier].
  const GenericComicNotifierFamily();

  /// See also [GenericComicNotifier].
  GenericComicNotifierProvider call({
    required int userId,
    required Future<Either<AppException, List<ComicModel>>> Function(
            {required String query, required int userId})
        fetch,
  }) {
    return GenericComicNotifierProvider(
      userId: userId,
      fetch: fetch,
    );
  }

  @override
  GenericComicNotifierProvider getProviderOverride(
    covariant GenericComicNotifierProvider provider,
  ) {
    return call(
      userId: provider.userId,
      fetch: provider.fetch,
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
  String? get name => r'genericComicNotifierProvider';
}

/// See also [GenericComicNotifier].
class GenericComicNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    GenericComicNotifier, List<ComicModel>> {
  /// See also [GenericComicNotifier].
  GenericComicNotifierProvider({
    required int userId,
    required Future<Either<AppException, List<ComicModel>>> Function(
            {required String query, required int userId})
        fetch,
  }) : this._internal(
          () => GenericComicNotifier()
            ..userId = userId
            ..fetch = fetch,
          from: genericComicNotifierProvider,
          name: r'genericComicNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$genericComicNotifierHash,
          dependencies: GenericComicNotifierFamily._dependencies,
          allTransitiveDependencies:
              GenericComicNotifierFamily._allTransitiveDependencies,
          userId: userId,
          fetch: fetch,
        );

  GenericComicNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
    required this.fetch,
  }) : super.internal();

  final int userId;
  final Future<Either<AppException, List<ComicModel>>> Function(
      {required String query, required int userId}) fetch;

  @override
  FutureOr<List<ComicModel>> runNotifierBuild(
    covariant GenericComicNotifier notifier,
  ) {
    return notifier.build(
      userId: userId,
      fetch: fetch,
    );
  }

  @override
  Override overrideWith(GenericComicNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: GenericComicNotifierProvider._internal(
        () => create()
          ..userId = userId
          ..fetch = fetch,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
        fetch: fetch,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<GenericComicNotifier,
      List<ComicModel>> createElement() {
    return _GenericComicNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GenericComicNotifierProvider &&
        other.userId == userId &&
        other.fetch == fetch;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);
    hash = _SystemHash.combine(hash, fetch.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin GenericComicNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<List<ComicModel>> {
  /// The parameter `userId` of this provider.
  int get userId;

  /// The parameter `fetch` of this provider.
  Future<Either<AppException, List<ComicModel>>> Function(
      {required String query, required int userId}) get fetch;
}

class _GenericComicNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<GenericComicNotifier,
        List<ComicModel>> with GenericComicNotifierRef {
  _GenericComicNotifierProviderElement(super.provider);

  @override
  int get userId => (origin as GenericComicNotifierProvider).userId;
  @override
  Future<Either<AppException, List<ComicModel>>> Function(
          {required String query, required int userId})
      get fetch => (origin as GenericComicNotifierProvider).fetch;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
