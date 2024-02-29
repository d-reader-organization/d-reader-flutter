// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  int get id => throw _privateConstructorUsedError;
  int get referralsRemaining => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get avatar => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  bool get isEmailVerified => throw _privateConstructorUsedError;
  bool get hasBetaAccess => throw _privateConstructorUsedError;
  List<String> get deviceTokens => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {int id,
      int referralsRemaining,
      String email,
      String avatar,
      String name,
      String role,
      bool isEmailVerified,
      bool hasBetaAccess,
      List<String> deviceTokens});
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referralsRemaining = null,
    Object? email = null,
    Object? avatar = null,
    Object? name = null,
    Object? role = null,
    Object? isEmailVerified = null,
    Object? hasBetaAccess = null,
    Object? deviceTokens = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      referralsRemaining: null == referralsRemaining
          ? _value.referralsRemaining
          : referralsRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      hasBetaAccess: null == hasBetaAccess
          ? _value.hasBetaAccess
          : hasBetaAccess // ignore: cast_nullable_to_non_nullable
              as bool,
      deviceTokens: null == deviceTokens
          ? _value.deviceTokens
          : deviceTokens // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int referralsRemaining,
      String email,
      String avatar,
      String name,
      String role,
      bool isEmailVerified,
      bool hasBetaAccess,
      List<String> deviceTokens});
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referralsRemaining = null,
    Object? email = null,
    Object? avatar = null,
    Object? name = null,
    Object? role = null,
    Object? isEmailVerified = null,
    Object? hasBetaAccess = null,
    Object? deviceTokens = null,
  }) {
    return _then(_$UserModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      referralsRemaining: null == referralsRemaining
          ? _value.referralsRemaining
          : referralsRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      hasBetaAccess: null == hasBetaAccess
          ? _value.hasBetaAccess
          : hasBetaAccess // ignore: cast_nullable_to_non_nullable
              as bool,
      deviceTokens: null == deviceTokens
          ? _value._deviceTokens
          : deviceTokens // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl with DiagnosticableTreeMixin implements _UserModel {
  const _$UserModelImpl(
      {required this.id,
      required this.referralsRemaining,
      required this.email,
      required this.avatar,
      required this.name,
      required this.role,
      required this.isEmailVerified,
      required this.hasBetaAccess,
      required final List<String> deviceTokens})
      : _deviceTokens = deviceTokens;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final int id;
  @override
  final int referralsRemaining;
  @override
  final String email;
  @override
  final String avatar;
  @override
  final String name;
  @override
  final String role;
  @override
  final bool isEmailVerified;
  @override
  final bool hasBetaAccess;
  final List<String> _deviceTokens;
  @override
  List<String> get deviceTokens {
    if (_deviceTokens is EqualUnmodifiableListView) return _deviceTokens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deviceTokens);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UserModel(id: $id, referralsRemaining: $referralsRemaining, email: $email, avatar: $avatar, name: $name, role: $role, isEmailVerified: $isEmailVerified, hasBetaAccess: $hasBetaAccess, deviceTokens: $deviceTokens)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UserModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('referralsRemaining', referralsRemaining))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('avatar', avatar))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('role', role))
      ..add(DiagnosticsProperty('isEmailVerified', isEmailVerified))
      ..add(DiagnosticsProperty('hasBetaAccess', hasBetaAccess))
      ..add(DiagnosticsProperty('deviceTokens', deviceTokens));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.referralsRemaining, referralsRemaining) ||
                other.referralsRemaining == referralsRemaining) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.hasBetaAccess, hasBetaAccess) ||
                other.hasBetaAccess == hasBetaAccess) &&
            const DeepCollectionEquality()
                .equals(other._deviceTokens, _deviceTokens));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      referralsRemaining,
      email,
      avatar,
      name,
      role,
      isEmailVerified,
      hasBetaAccess,
      const DeepCollectionEquality().hash(_deviceTokens));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
      {required final int id,
      required final int referralsRemaining,
      required final String email,
      required final String avatar,
      required final String name,
      required final String role,
      required final bool isEmailVerified,
      required final bool hasBetaAccess,
      required final List<String> deviceTokens}) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  int get id;
  @override
  int get referralsRemaining;
  @override
  String get email;
  @override
  String get avatar;
  @override
  String get name;
  @override
  String get role;
  @override
  bool get isEmailVerified;
  @override
  bool get hasBetaAccess;
  @override
  List<String> get deviceTokens;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UpdateUserPayload {
  int get id => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get referrer => throw _privateConstructorUsedError;
  File? get avatar => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UpdateUserPayloadCopyWith<UpdateUserPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateUserPayloadCopyWith<$Res> {
  factory $UpdateUserPayloadCopyWith(
          UpdateUserPayload value, $Res Function(UpdateUserPayload) then) =
      _$UpdateUserPayloadCopyWithImpl<$Res, UpdateUserPayload>;
  @useResult
  $Res call(
      {int id, String? email, String? name, String? referrer, File? avatar});
}

/// @nodoc
class _$UpdateUserPayloadCopyWithImpl<$Res, $Val extends UpdateUserPayload>
    implements $UpdateUserPayloadCopyWith<$Res> {
  _$UpdateUserPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = freezed,
    Object? name = freezed,
    Object? referrer = freezed,
    Object? avatar = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      referrer: freezed == referrer
          ? _value.referrer
          : referrer // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as File?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateUserPayloadImplCopyWith<$Res>
    implements $UpdateUserPayloadCopyWith<$Res> {
  factory _$$UpdateUserPayloadImplCopyWith(_$UpdateUserPayloadImpl value,
          $Res Function(_$UpdateUserPayloadImpl) then) =
      __$$UpdateUserPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id, String? email, String? name, String? referrer, File? avatar});
}

/// @nodoc
class __$$UpdateUserPayloadImplCopyWithImpl<$Res>
    extends _$UpdateUserPayloadCopyWithImpl<$Res, _$UpdateUserPayloadImpl>
    implements _$$UpdateUserPayloadImplCopyWith<$Res> {
  __$$UpdateUserPayloadImplCopyWithImpl(_$UpdateUserPayloadImpl _value,
      $Res Function(_$UpdateUserPayloadImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = freezed,
    Object? name = freezed,
    Object? referrer = freezed,
    Object? avatar = freezed,
  }) {
    return _then(_$UpdateUserPayloadImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      referrer: freezed == referrer
          ? _value.referrer
          : referrer // ignore: cast_nullable_to_non_nullable
              as String?,
      avatar: freezed == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as File?,
    ));
  }
}

/// @nodoc

class _$UpdateUserPayloadImpl
    with DiagnosticableTreeMixin
    implements _UpdateUserPayload {
  const _$UpdateUserPayloadImpl(
      {required this.id, this.email, this.name, this.referrer, this.avatar});

  @override
  final int id;
  @override
  final String? email;
  @override
  final String? name;
  @override
  final String? referrer;
  @override
  final File? avatar;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'UpdateUserPayload(id: $id, email: $email, name: $name, referrer: $referrer, avatar: $avatar)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'UpdateUserPayload'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('referrer', referrer))
      ..add(DiagnosticsProperty('avatar', avatar));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserPayloadImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.referrer, referrer) ||
                other.referrer == referrer) &&
            const DeepCollectionEquality().equals(other.avatar, avatar));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, email, name, referrer,
      const DeepCollectionEquality().hash(avatar));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateUserPayloadImplCopyWith<_$UpdateUserPayloadImpl> get copyWith =>
      __$$UpdateUserPayloadImplCopyWithImpl<_$UpdateUserPayloadImpl>(
          this, _$identity);
}

abstract class _UpdateUserPayload implements UpdateUserPayload {
  const factory _UpdateUserPayload(
      {required final int id,
      final String? email,
      final String? name,
      final String? referrer,
      final File? avatar}) = _$UpdateUserPayloadImpl;

  @override
  int get id;
  @override
  String? get email;
  @override
  String? get name;
  @override
  String? get referrer;
  @override
  File? get avatar;
  @override
  @JsonKey(ignore: true)
  _$$UpdateUserPayloadImplCopyWith<_$UpdateUserPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
