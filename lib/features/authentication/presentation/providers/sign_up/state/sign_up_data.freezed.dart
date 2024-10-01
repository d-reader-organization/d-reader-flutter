// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_up_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SignUpData {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get googleAccessToken => throw _privateConstructorUsedError;
  bool get isSuccess => throw _privateConstructorUsedError;

  /// Create a copy of SignUpData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SignUpDataCopyWith<SignUpData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignUpDataCopyWith<$Res> {
  factory $SignUpDataCopyWith(
          SignUpData value, $Res Function(SignUpData) then) =
      _$SignUpDataCopyWithImpl<$Res, SignUpData>;
  @useResult
  $Res call(
      {String email,
      String password,
      String username,
      String googleAccessToken,
      bool isSuccess});
}

/// @nodoc
class _$SignUpDataCopyWithImpl<$Res, $Val extends SignUpData>
    implements $SignUpDataCopyWith<$Res> {
  _$SignUpDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SignUpData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? username = null,
    Object? googleAccessToken = null,
    Object? isSuccess = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      googleAccessToken: null == googleAccessToken
          ? _value.googleAccessToken
          : googleAccessToken // ignore: cast_nullable_to_non_nullable
              as String,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SignUpDataImplCopyWith<$Res>
    implements $SignUpDataCopyWith<$Res> {
  factory _$$SignUpDataImplCopyWith(
          _$SignUpDataImpl value, $Res Function(_$SignUpDataImpl) then) =
      __$$SignUpDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email,
      String password,
      String username,
      String googleAccessToken,
      bool isSuccess});
}

/// @nodoc
class __$$SignUpDataImplCopyWithImpl<$Res>
    extends _$SignUpDataCopyWithImpl<$Res, _$SignUpDataImpl>
    implements _$$SignUpDataImplCopyWith<$Res> {
  __$$SignUpDataImplCopyWithImpl(
      _$SignUpDataImpl _value, $Res Function(_$SignUpDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of SignUpData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
    Object? username = null,
    Object? googleAccessToken = null,
    Object? isSuccess = null,
  }) {
    return _then(_$SignUpDataImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      googleAccessToken: null == googleAccessToken
          ? _value.googleAccessToken
          : googleAccessToken // ignore: cast_nullable_to_non_nullable
              as String,
      isSuccess: null == isSuccess
          ? _value.isSuccess
          : isSuccess // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SignUpDataImpl implements _SignUpData {
  const _$SignUpDataImpl(
      {this.email = '',
      this.password = '',
      this.username = '',
      this.googleAccessToken = '',
      this.isSuccess = false});

  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey()
  final String username;
  @override
  @JsonKey()
  final String googleAccessToken;
  @override
  @JsonKey()
  final bool isSuccess;

  @override
  String toString() {
    return 'SignUpData(email: $email, password: $password, username: $username, googleAccessToken: $googleAccessToken, isSuccess: $isSuccess)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignUpDataImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.googleAccessToken, googleAccessToken) ||
                other.googleAccessToken == googleAccessToken) &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, email, password, username, googleAccessToken, isSuccess);

  /// Create a copy of SignUpData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SignUpDataImplCopyWith<_$SignUpDataImpl> get copyWith =>
      __$$SignUpDataImplCopyWithImpl<_$SignUpDataImpl>(this, _$identity);
}

abstract class _SignUpData implements SignUpData {
  const factory _SignUpData(
      {final String email,
      final String password,
      final String username,
      final String googleAccessToken,
      final bool isSuccess}) = _$SignUpDataImpl;

  @override
  String get email;
  @override
  String get password;
  @override
  String get username;
  @override
  String get googleAccessToken;
  @override
  bool get isSuccess;

  /// Create a copy of SignUpData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SignUpDataImplCopyWith<_$SignUpDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
