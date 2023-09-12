// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signInFutureHash() => r'453180968ee458388a011e30c83f2f067ad9fb71';

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

/// See also [signInFuture].
@ProviderFor(signInFuture)
const signInFutureProvider = SignInFutureFamily();

/// See also [signInFuture].
class SignInFutureFamily extends Family<AsyncValue<dynamic>> {
  /// See also [signInFuture].
  const SignInFutureFamily();

  /// See also [signInFuture].
  SignInFutureProvider call({
    required String nameOrEmail,
    required String password,
  }) {
    return SignInFutureProvider(
      nameOrEmail: nameOrEmail,
      password: password,
    );
  }

  @override
  SignInFutureProvider getProviderOverride(
    covariant SignInFutureProvider provider,
  ) {
    return call(
      nameOrEmail: provider.nameOrEmail,
      password: provider.password,
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
  String? get name => r'signInFutureProvider';
}

/// See also [signInFuture].
class SignInFutureProvider extends AutoDisposeFutureProvider<dynamic> {
  /// See also [signInFuture].
  SignInFutureProvider({
    required String nameOrEmail,
    required String password,
  }) : this._internal(
          (ref) => signInFuture(
            ref as SignInFutureRef,
            nameOrEmail: nameOrEmail,
            password: password,
          ),
          from: signInFutureProvider,
          name: r'signInFutureProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$signInFutureHash,
          dependencies: SignInFutureFamily._dependencies,
          allTransitiveDependencies:
              SignInFutureFamily._allTransitiveDependencies,
          nameOrEmail: nameOrEmail,
          password: password,
        );

  SignInFutureProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.nameOrEmail,
    required this.password,
  }) : super.internal();

  final String nameOrEmail;
  final String password;

  @override
  Override overrideWith(
    FutureOr<dynamic> Function(SignInFutureRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SignInFutureProvider._internal(
        (ref) => create(ref as SignInFutureRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        nameOrEmail: nameOrEmail,
        password: password,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<dynamic> createElement() {
    return _SignInFutureProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SignInFutureProvider &&
        other.nameOrEmail == nameOrEmail &&
        other.password == password;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, nameOrEmail.hashCode);
    hash = _SystemHash.combine(hash, password.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SignInFutureRef on AutoDisposeFutureProviderRef<dynamic> {
  /// The parameter `nameOrEmail` of this provider.
  String get nameOrEmail;

  /// The parameter `password` of this provider.
  String get password;
}

class _SignInFutureProviderElement
    extends AutoDisposeFutureProviderElement<dynamic> with SignInFutureRef {
  _SignInFutureProviderElement(super.provider);

  @override
  String get nameOrEmail => (origin as SignInFutureProvider).nameOrEmail;
  @override
  String get password => (origin as SignInFutureProvider).password;
}

String _$signUpFutureHash() => r'511439bfc7bd948497098cf3b55a9aedc18c1c77';

/// See also [signUpFuture].
@ProviderFor(signUpFuture)
final signUpFutureProvider = AutoDisposeFutureProvider<dynamic>.internal(
  signUpFuture,
  name: r'signUpFutureProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$signUpFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SignUpFutureRef = AutoDisposeFutureProviderRef<dynamic>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
