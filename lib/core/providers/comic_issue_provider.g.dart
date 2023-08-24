// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comic_issue_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ownedIssuesHash() => r'f7208f86f7e669fddfc80e209170e2d68be267fb';

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

typedef OwnedIssuesRef = AutoDisposeFutureProviderRef<List<OwnedComicIssue>>;

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
    required this.userId,
    required this.query,
  }) : super.internal(
          (ref) => ownedIssues(
            ref,
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
        );

  final int userId;
  final String query;

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
