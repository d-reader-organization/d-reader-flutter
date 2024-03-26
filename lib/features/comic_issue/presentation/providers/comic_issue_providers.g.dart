// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic_issue_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$comicIssueDetailsHash() => r'850ab351782b6d72c9bd5ac6ed34ddb6d9ead34c';

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

/// See also [comicIssueDetails].
@ProviderFor(comicIssueDetails)
const comicIssueDetailsProvider = ComicIssueDetailsFamily();

/// See also [comicIssueDetails].
class ComicIssueDetailsFamily extends Family<AsyncValue<ComicIssueModel>> {
  /// See also [comicIssueDetails].
  const ComicIssueDetailsFamily();

  /// See also [comicIssueDetails].
  ComicIssueDetailsProvider call(
    String id,
  ) {
    return ComicIssueDetailsProvider(
      id,
    );
  }

  @override
  ComicIssueDetailsProvider getProviderOverride(
    covariant ComicIssueDetailsProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'comicIssueDetailsProvider';
}

/// See also [comicIssueDetails].
class ComicIssueDetailsProvider
    extends AutoDisposeFutureProvider<ComicIssueModel> {
  /// See also [comicIssueDetails].
  ComicIssueDetailsProvider(
    String id,
  ) : this._internal(
          (ref) => comicIssueDetails(
            ref as ComicIssueDetailsRef,
            id,
          ),
          from: comicIssueDetailsProvider,
          name: r'comicIssueDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$comicIssueDetailsHash,
          dependencies: ComicIssueDetailsFamily._dependencies,
          allTransitiveDependencies:
              ComicIssueDetailsFamily._allTransitiveDependencies,
          id: id,
        );

  ComicIssueDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<ComicIssueModel> Function(ComicIssueDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ComicIssueDetailsProvider._internal(
        (ref) => create(ref as ComicIssueDetailsRef),
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
  AutoDisposeFutureProviderElement<ComicIssueModel> createElement() {
    return _ComicIssueDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ComicIssueDetailsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ComicIssueDetailsRef on AutoDisposeFutureProviderRef<ComicIssueModel> {
  /// The parameter `id` of this provider.
  String get id;
}

class _ComicIssueDetailsProviderElement
    extends AutoDisposeFutureProviderElement<ComicIssueModel>
    with ComicIssueDetailsRef {
  _ComicIssueDetailsProviderElement(super.provider);

  @override
  String get id => (origin as ComicIssueDetailsProvider).id;
}

String _$ownedIssuesHash() => r'833c572384821b22a8c5e23b2e55228f9a713613';

/// See also [ownedIssues].
@ProviderFor(ownedIssues)
const ownedIssuesProvider = OwnedIssuesFamily();

/// See also [ownedIssues].
class OwnedIssuesFamily extends Family<AsyncValue<List<OwnedComicIssue>>> {
  /// See also [ownedIssues].
  const OwnedIssuesFamily();

  /// See also [ownedIssues].
  OwnedIssuesProvider call({
    required int userId,
    required String query,
  }) {
    return OwnedIssuesProvider(
      userId: userId,
      query: query,
    );
  }

  @override
  OwnedIssuesProvider getProviderOverride(
    covariant OwnedIssuesProvider provider,
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
  String? get name => r'ownedIssuesProvider';
}

/// See also [ownedIssues].
class OwnedIssuesProvider
    extends AutoDisposeFutureProvider<List<OwnedComicIssue>> {
  /// See also [ownedIssues].
  OwnedIssuesProvider({
    required int userId,
    required String query,
  }) : this._internal(
          (ref) => ownedIssues(
            ref as OwnedIssuesRef,
            userId: userId,
            query: query,
          ),
          from: ownedIssuesProvider,
          name: r'ownedIssuesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$ownedIssuesHash,
          dependencies: OwnedIssuesFamily._dependencies,
          allTransitiveDependencies:
              OwnedIssuesFamily._allTransitiveDependencies,
          userId: userId,
          query: query,
        );

  OwnedIssuesProvider._internal(
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
    FutureOr<List<OwnedComicIssue>> Function(OwnedIssuesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OwnedIssuesProvider._internal(
        (ref) => create(ref as OwnedIssuesRef),
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
  AutoDisposeFutureProviderElement<List<OwnedComicIssue>> createElement() {
    return _OwnedIssuesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OwnedIssuesProvider &&
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

mixin OwnedIssuesRef on AutoDisposeFutureProviderRef<List<OwnedComicIssue>> {
  /// The parameter `userId` of this provider.
  int get userId;

  /// The parameter `query` of this provider.
  String get query;
}

class _OwnedIssuesProviderElement
    extends AutoDisposeFutureProviderElement<List<OwnedComicIssue>>
    with OwnedIssuesRef {
  _OwnedIssuesProviderElement(super.provider);

  @override
  int get userId => (origin as OwnedIssuesProvider).userId;
  @override
  String get query => (origin as OwnedIssuesProvider).query;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
