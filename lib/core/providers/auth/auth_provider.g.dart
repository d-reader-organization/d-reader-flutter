// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signInHash() => r'437c969cb034ebf9d886450706bfad633f48c144';

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

/// See also [signIn].
@ProviderFor(signIn)
const signInProvider = SignInFamily();

/// See also [signIn].
class SignInFamily extends Family<AsyncValue<dynamic>> {
  /// See also [signIn].
  const SignInFamily();

  /// See also [signIn].
  SignInProvider call({
    required String nameOrEmail,
    required String password,
  }) {
    return SignInProvider(
      nameOrEmail: nameOrEmail,
      password: password,
    );
  }

  @override
  SignInProvider getProviderOverride(
    covariant SignInProvider provider,
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
  String? get name => r'signInProvider';
}

/// See also [signIn].
class SignInProvider extends AutoDisposeFutureProvider<dynamic> {
  /// See also [signIn].
  SignInProvider({
    required String nameOrEmail,
    required String password,
  }) : this._internal(
          (ref) => signIn(
            ref as SignInRef,
            nameOrEmail: nameOrEmail,
            password: password,
          ),
          from: signInProvider,
          name: r'signInProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$signInHash,
          dependencies: SignInFamily._dependencies,
          allTransitiveDependencies: SignInFamily._allTransitiveDependencies,
          nameOrEmail: nameOrEmail,
          password: password,
        );

  SignInProvider._internal(
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
    FutureOr<dynamic> Function(SignInRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SignInProvider._internal(
        (ref) => create(ref as SignInRef),
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
    return _SignInProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SignInProvider &&
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

mixin SignInRef on AutoDisposeFutureProviderRef<dynamic> {
  /// The parameter `nameOrEmail` of this provider.
  String get nameOrEmail;

  /// The parameter `password` of this provider.
  String get password;
}

class _SignInProviderElement extends AutoDisposeFutureProviderElement<dynamic>
    with SignInRef {
  _SignInProviderElement(super.provider);

  @override
  String get nameOrEmail => (origin as SignInProvider).nameOrEmail;
  @override
  String get password => (origin as SignInProvider).password;
}

String _$signUpFutureHash() => r'db66049ad43c3a42c4b5fcc5927160e53955ac03';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
