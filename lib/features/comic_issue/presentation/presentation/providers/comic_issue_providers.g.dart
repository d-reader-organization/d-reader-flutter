// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic_issue_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$comicIssueDetailsHash() => r'db5ff4821a307ad9c88b5a7f86a243e972b45a22';

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
    int id,
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
    int id,
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

  final int id;

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
  int get id;
}

class _ComicIssueDetailsProviderElement
    extends AutoDisposeFutureProviderElement<ComicIssueModel>
    with ComicIssueDetailsRef {
  _ComicIssueDetailsProviderElement(super.provider);

  @override
  int get id => (origin as ComicIssueDetailsProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
