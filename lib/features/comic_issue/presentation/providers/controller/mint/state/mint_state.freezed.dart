// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mint_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MintState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() minting,
    required TResult Function(String message) failed,
    required TResult Function(String message) success,
    required TResult Function() verificationNeeded,
    required TResult Function() initialized,
    required TResult Function(AppException exception) failedWithException,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? minting,
    TResult? Function(String message)? failed,
    TResult? Function(String message)? success,
    TResult? Function()? verificationNeeded,
    TResult? Function()? initialized,
    TResult? Function(AppException exception)? failedWithException,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? minting,
    TResult Function(String message)? failed,
    TResult Function(String message)? success,
    TResult Function()? verificationNeeded,
    TResult Function()? initialized,
    TResult Function(AppException exception)? failedWithException,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Minting value) minting,
    required TResult Function(_Failed value) failed,
    required TResult Function(_Success value) success,
    required TResult Function(_VerificationNeeded value) verificationNeeded,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_FailedWithException value) failedWithException,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Minting value)? minting,
    TResult? Function(_Failed value)? failed,
    TResult? Function(_Success value)? success,
    TResult? Function(_VerificationNeeded value)? verificationNeeded,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_FailedWithException value)? failedWithException,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Minting value)? minting,
    TResult Function(_Failed value)? failed,
    TResult Function(_Success value)? success,
    TResult Function(_VerificationNeeded value)? verificationNeeded,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_FailedWithException value)? failedWithException,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MintStateCopyWith<$Res> {
  factory $MintStateCopyWith(MintState value, $Res Function(MintState) then) =
      _$MintStateCopyWithImpl<$Res, MintState>;
}

/// @nodoc
class _$MintStateCopyWithImpl<$Res, $Val extends MintState>
    implements $MintStateCopyWith<$Res> {
  _$MintStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$MintingImplCopyWith<$Res> {
  factory _$$MintingImplCopyWith(
          _$MintingImpl value, $Res Function(_$MintingImpl) then) =
      __$$MintingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MintingImplCopyWithImpl<$Res>
    extends _$MintStateCopyWithImpl<$Res, _$MintingImpl>
    implements _$$MintingImplCopyWith<$Res> {
  __$$MintingImplCopyWithImpl(
      _$MintingImpl _value, $Res Function(_$MintingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$MintingImpl implements _Minting {
  const _$MintingImpl();

  @override
  String toString() {
    return 'MintState.minting()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$MintingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() minting,
    required TResult Function(String message) failed,
    required TResult Function(String message) success,
    required TResult Function() verificationNeeded,
    required TResult Function() initialized,
    required TResult Function(AppException exception) failedWithException,
  }) {
    return minting();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? minting,
    TResult? Function(String message)? failed,
    TResult? Function(String message)? success,
    TResult? Function()? verificationNeeded,
    TResult? Function()? initialized,
    TResult? Function(AppException exception)? failedWithException,
  }) {
    return minting?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? minting,
    TResult Function(String message)? failed,
    TResult Function(String message)? success,
    TResult Function()? verificationNeeded,
    TResult Function()? initialized,
    TResult Function(AppException exception)? failedWithException,
    required TResult orElse(),
  }) {
    if (minting != null) {
      return minting();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Minting value) minting,
    required TResult Function(_Failed value) failed,
    required TResult Function(_Success value) success,
    required TResult Function(_VerificationNeeded value) verificationNeeded,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_FailedWithException value) failedWithException,
  }) {
    return minting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Minting value)? minting,
    TResult? Function(_Failed value)? failed,
    TResult? Function(_Success value)? success,
    TResult? Function(_VerificationNeeded value)? verificationNeeded,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_FailedWithException value)? failedWithException,
  }) {
    return minting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Minting value)? minting,
    TResult Function(_Failed value)? failed,
    TResult Function(_Success value)? success,
    TResult Function(_VerificationNeeded value)? verificationNeeded,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_FailedWithException value)? failedWithException,
    required TResult orElse(),
  }) {
    if (minting != null) {
      return minting(this);
    }
    return orElse();
  }
}

abstract class _Minting implements MintState {
  const factory _Minting() = _$MintingImpl;
}

/// @nodoc
abstract class _$$FailedImplCopyWith<$Res> {
  factory _$$FailedImplCopyWith(
          _$FailedImpl value, $Res Function(_$FailedImpl) then) =
      __$$FailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$FailedImplCopyWithImpl<$Res>
    extends _$MintStateCopyWithImpl<$Res, _$FailedImpl>
    implements _$$FailedImplCopyWith<$Res> {
  __$$FailedImplCopyWithImpl(
      _$FailedImpl _value, $Res Function(_$FailedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$FailedImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$FailedImpl implements _Failed {
  const _$FailedImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'MintState.failed(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailedImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FailedImplCopyWith<_$FailedImpl> get copyWith =>
      __$$FailedImplCopyWithImpl<_$FailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() minting,
    required TResult Function(String message) failed,
    required TResult Function(String message) success,
    required TResult Function() verificationNeeded,
    required TResult Function() initialized,
    required TResult Function(AppException exception) failedWithException,
  }) {
    return failed(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? minting,
    TResult? Function(String message)? failed,
    TResult? Function(String message)? success,
    TResult? Function()? verificationNeeded,
    TResult? Function()? initialized,
    TResult? Function(AppException exception)? failedWithException,
  }) {
    return failed?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? minting,
    TResult Function(String message)? failed,
    TResult Function(String message)? success,
    TResult Function()? verificationNeeded,
    TResult Function()? initialized,
    TResult Function(AppException exception)? failedWithException,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Minting value) minting,
    required TResult Function(_Failed value) failed,
    required TResult Function(_Success value) success,
    required TResult Function(_VerificationNeeded value) verificationNeeded,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_FailedWithException value) failedWithException,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Minting value)? minting,
    TResult? Function(_Failed value)? failed,
    TResult? Function(_Success value)? success,
    TResult? Function(_VerificationNeeded value)? verificationNeeded,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_FailedWithException value)? failedWithException,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Minting value)? minting,
    TResult Function(_Failed value)? failed,
    TResult Function(_Success value)? success,
    TResult Function(_VerificationNeeded value)? verificationNeeded,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_FailedWithException value)? failedWithException,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class _Failed implements MintState {
  const factory _Failed(final String message) = _$FailedImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$FailedImplCopyWith<_$FailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<$Res> {
  factory _$$SuccessImplCopyWith(
          _$SuccessImpl value, $Res Function(_$SuccessImpl) then) =
      __$$SuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<$Res>
    extends _$MintStateCopyWithImpl<$Res, _$SuccessImpl>
    implements _$$SuccessImplCopyWith<$Res> {
  __$$SuccessImplCopyWithImpl(
      _$SuccessImpl _value, $Res Function(_$SuccessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$SuccessImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SuccessImpl implements _Success {
  const _$SuccessImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'MintState.success(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      __$$SuccessImplCopyWithImpl<_$SuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() minting,
    required TResult Function(String message) failed,
    required TResult Function(String message) success,
    required TResult Function() verificationNeeded,
    required TResult Function() initialized,
    required TResult Function(AppException exception) failedWithException,
  }) {
    return success(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? minting,
    TResult? Function(String message)? failed,
    TResult? Function(String message)? success,
    TResult? Function()? verificationNeeded,
    TResult? Function()? initialized,
    TResult? Function(AppException exception)? failedWithException,
  }) {
    return success?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? minting,
    TResult Function(String message)? failed,
    TResult Function(String message)? success,
    TResult Function()? verificationNeeded,
    TResult Function()? initialized,
    TResult Function(AppException exception)? failedWithException,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Minting value) minting,
    required TResult Function(_Failed value) failed,
    required TResult Function(_Success value) success,
    required TResult Function(_VerificationNeeded value) verificationNeeded,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_FailedWithException value) failedWithException,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Minting value)? minting,
    TResult? Function(_Failed value)? failed,
    TResult? Function(_Success value)? success,
    TResult? Function(_VerificationNeeded value)? verificationNeeded,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_FailedWithException value)? failedWithException,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Minting value)? minting,
    TResult Function(_Failed value)? failed,
    TResult Function(_Success value)? success,
    TResult Function(_VerificationNeeded value)? verificationNeeded,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_FailedWithException value)? failedWithException,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _Success implements MintState {
  const factory _Success(final String message) = _$SuccessImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$VerificationNeededImplCopyWith<$Res> {
  factory _$$VerificationNeededImplCopyWith(_$VerificationNeededImpl value,
          $Res Function(_$VerificationNeededImpl) then) =
      __$$VerificationNeededImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$VerificationNeededImplCopyWithImpl<$Res>
    extends _$MintStateCopyWithImpl<$Res, _$VerificationNeededImpl>
    implements _$$VerificationNeededImplCopyWith<$Res> {
  __$$VerificationNeededImplCopyWithImpl(_$VerificationNeededImpl _value,
      $Res Function(_$VerificationNeededImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$VerificationNeededImpl implements _VerificationNeeded {
  const _$VerificationNeededImpl();

  @override
  String toString() {
    return 'MintState.verificationNeeded()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$VerificationNeededImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() minting,
    required TResult Function(String message) failed,
    required TResult Function(String message) success,
    required TResult Function() verificationNeeded,
    required TResult Function() initialized,
    required TResult Function(AppException exception) failedWithException,
  }) {
    return verificationNeeded();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? minting,
    TResult? Function(String message)? failed,
    TResult? Function(String message)? success,
    TResult? Function()? verificationNeeded,
    TResult? Function()? initialized,
    TResult? Function(AppException exception)? failedWithException,
  }) {
    return verificationNeeded?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? minting,
    TResult Function(String message)? failed,
    TResult Function(String message)? success,
    TResult Function()? verificationNeeded,
    TResult Function()? initialized,
    TResult Function(AppException exception)? failedWithException,
    required TResult orElse(),
  }) {
    if (verificationNeeded != null) {
      return verificationNeeded();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Minting value) minting,
    required TResult Function(_Failed value) failed,
    required TResult Function(_Success value) success,
    required TResult Function(_VerificationNeeded value) verificationNeeded,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_FailedWithException value) failedWithException,
  }) {
    return verificationNeeded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Minting value)? minting,
    TResult? Function(_Failed value)? failed,
    TResult? Function(_Success value)? success,
    TResult? Function(_VerificationNeeded value)? verificationNeeded,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_FailedWithException value)? failedWithException,
  }) {
    return verificationNeeded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Minting value)? minting,
    TResult Function(_Failed value)? failed,
    TResult Function(_Success value)? success,
    TResult Function(_VerificationNeeded value)? verificationNeeded,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_FailedWithException value)? failedWithException,
    required TResult orElse(),
  }) {
    if (verificationNeeded != null) {
      return verificationNeeded(this);
    }
    return orElse();
  }
}

abstract class _VerificationNeeded implements MintState {
  const factory _VerificationNeeded() = _$VerificationNeededImpl;
}

/// @nodoc
abstract class _$$InitializedImplCopyWith<$Res> {
  factory _$$InitializedImplCopyWith(
          _$InitializedImpl value, $Res Function(_$InitializedImpl) then) =
      __$$InitializedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitializedImplCopyWithImpl<$Res>
    extends _$MintStateCopyWithImpl<$Res, _$InitializedImpl>
    implements _$$InitializedImplCopyWith<$Res> {
  __$$InitializedImplCopyWithImpl(
      _$InitializedImpl _value, $Res Function(_$InitializedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitializedImpl implements _Initialized {
  const _$InitializedImpl();

  @override
  String toString() {
    return 'MintState.initialized()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitializedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() minting,
    required TResult Function(String message) failed,
    required TResult Function(String message) success,
    required TResult Function() verificationNeeded,
    required TResult Function() initialized,
    required TResult Function(AppException exception) failedWithException,
  }) {
    return initialized();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? minting,
    TResult? Function(String message)? failed,
    TResult? Function(String message)? success,
    TResult? Function()? verificationNeeded,
    TResult? Function()? initialized,
    TResult? Function(AppException exception)? failedWithException,
  }) {
    return initialized?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? minting,
    TResult Function(String message)? failed,
    TResult Function(String message)? success,
    TResult Function()? verificationNeeded,
    TResult Function()? initialized,
    TResult Function(AppException exception)? failedWithException,
    required TResult orElse(),
  }) {
    if (initialized != null) {
      return initialized();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Minting value) minting,
    required TResult Function(_Failed value) failed,
    required TResult Function(_Success value) success,
    required TResult Function(_VerificationNeeded value) verificationNeeded,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_FailedWithException value) failedWithException,
  }) {
    return initialized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Minting value)? minting,
    TResult? Function(_Failed value)? failed,
    TResult? Function(_Success value)? success,
    TResult? Function(_VerificationNeeded value)? verificationNeeded,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_FailedWithException value)? failedWithException,
  }) {
    return initialized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Minting value)? minting,
    TResult Function(_Failed value)? failed,
    TResult Function(_Success value)? success,
    TResult Function(_VerificationNeeded value)? verificationNeeded,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_FailedWithException value)? failedWithException,
    required TResult orElse(),
  }) {
    if (initialized != null) {
      return initialized(this);
    }
    return orElse();
  }
}

abstract class _Initialized implements MintState {
  const factory _Initialized() = _$InitializedImpl;
}

/// @nodoc
abstract class _$$FailedWithExceptionImplCopyWith<$Res> {
  factory _$$FailedWithExceptionImplCopyWith(_$FailedWithExceptionImpl value,
          $Res Function(_$FailedWithExceptionImpl) then) =
      __$$FailedWithExceptionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({AppException exception});
}

/// @nodoc
class __$$FailedWithExceptionImplCopyWithImpl<$Res>
    extends _$MintStateCopyWithImpl<$Res, _$FailedWithExceptionImpl>
    implements _$$FailedWithExceptionImplCopyWith<$Res> {
  __$$FailedWithExceptionImplCopyWithImpl(_$FailedWithExceptionImpl _value,
      $Res Function(_$FailedWithExceptionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? exception = freezed,
  }) {
    return _then(_$FailedWithExceptionImpl(
      freezed == exception
          ? _value.exception
          : exception // ignore: cast_nullable_to_non_nullable
              as AppException,
    ));
  }
}

/// @nodoc

class _$FailedWithExceptionImpl implements _FailedWithException {
  const _$FailedWithExceptionImpl(this.exception);

  @override
  final AppException exception;

  @override
  String toString() {
    return 'MintState.failedWithException(exception: $exception)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FailedWithExceptionImpl &&
            const DeepCollectionEquality().equals(other.exception, exception));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(exception));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FailedWithExceptionImplCopyWith<_$FailedWithExceptionImpl> get copyWith =>
      __$$FailedWithExceptionImplCopyWithImpl<_$FailedWithExceptionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() minting,
    required TResult Function(String message) failed,
    required TResult Function(String message) success,
    required TResult Function() verificationNeeded,
    required TResult Function() initialized,
    required TResult Function(AppException exception) failedWithException,
  }) {
    return failedWithException(exception);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? minting,
    TResult? Function(String message)? failed,
    TResult? Function(String message)? success,
    TResult? Function()? verificationNeeded,
    TResult? Function()? initialized,
    TResult? Function(AppException exception)? failedWithException,
  }) {
    return failedWithException?.call(exception);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? minting,
    TResult Function(String message)? failed,
    TResult Function(String message)? success,
    TResult Function()? verificationNeeded,
    TResult Function()? initialized,
    TResult Function(AppException exception)? failedWithException,
    required TResult orElse(),
  }) {
    if (failedWithException != null) {
      return failedWithException(exception);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Minting value) minting,
    required TResult Function(_Failed value) failed,
    required TResult Function(_Success value) success,
    required TResult Function(_VerificationNeeded value) verificationNeeded,
    required TResult Function(_Initialized value) initialized,
    required TResult Function(_FailedWithException value) failedWithException,
  }) {
    return failedWithException(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Minting value)? minting,
    TResult? Function(_Failed value)? failed,
    TResult? Function(_Success value)? success,
    TResult? Function(_VerificationNeeded value)? verificationNeeded,
    TResult? Function(_Initialized value)? initialized,
    TResult? Function(_FailedWithException value)? failedWithException,
  }) {
    return failedWithException?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Minting value)? minting,
    TResult Function(_Failed value)? failed,
    TResult Function(_Success value)? success,
    TResult Function(_VerificationNeeded value)? verificationNeeded,
    TResult Function(_Initialized value)? initialized,
    TResult Function(_FailedWithException value)? failedWithException,
    required TResult orElse(),
  }) {
    if (failedWithException != null) {
      return failedWithException(this);
    }
    return orElse();
  }
}

abstract class _FailedWithException implements MintState {
  const factory _FailedWithException(final AppException exception) =
      _$FailedWithExceptionImpl;

  AppException get exception;
  @JsonKey(ignore: true)
  _$$FailedWithExceptionImplCopyWith<_$FailedWithExceptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$MintTransactionsResponse {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> data) ok,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> data)? ok,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> data)? ok,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Ok value) ok,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Ok value)? ok,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Ok value)? ok,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MintTransactionsResponseCopyWith<$Res> {
  factory $MintTransactionsResponseCopyWith(MintTransactionsResponse value,
          $Res Function(MintTransactionsResponse) then) =
      _$MintTransactionsResponseCopyWithImpl<$Res, MintTransactionsResponse>;
}

/// @nodoc
class _$MintTransactionsResponseCopyWithImpl<$Res,
        $Val extends MintTransactionsResponse>
    implements $MintTransactionsResponseCopyWith<$Res> {
  _$MintTransactionsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$OkImplCopyWith<$Res> {
  factory _$$OkImplCopyWith(_$OkImpl value, $Res Function(_$OkImpl) then) =
      __$$OkImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> data});
}

/// @nodoc
class __$$OkImplCopyWithImpl<$Res>
    extends _$MintTransactionsResponseCopyWithImpl<$Res, _$OkImpl>
    implements _$$OkImplCopyWith<$Res> {
  __$$OkImplCopyWithImpl(_$OkImpl _value, $Res Function(_$OkImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$OkImpl(
      null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$OkImpl implements _Ok {
  const _$OkImpl(final List<String> data) : _data = data;

  final List<String> _data;
  @override
  List<String> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString() {
    return 'MintTransactionsResponse.ok(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OkImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OkImplCopyWith<_$OkImpl> get copyWith =>
      __$$OkImplCopyWithImpl<_$OkImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> data) ok,
    required TResult Function(String message) error,
  }) {
    return ok(data);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> data)? ok,
    TResult? Function(String message)? error,
  }) {
    return ok?.call(data);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> data)? ok,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (ok != null) {
      return ok(data);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Ok value) ok,
    required TResult Function(_Error value) error,
  }) {
    return ok(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Ok value)? ok,
    TResult? Function(_Error value)? error,
  }) {
    return ok?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Ok value)? ok,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (ok != null) {
      return ok(this);
    }
    return orElse();
  }
}

abstract class _Ok implements MintTransactionsResponse {
  const factory _Ok(final List<String> data) = _$OkImpl;

  List<String> get data;
  @JsonKey(ignore: true)
  _$$OkImplCopyWith<_$OkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$MintTransactionsResponseCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'MintTransactionsResponse.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<String> data) ok,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<String> data)? ok,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<String> data)? ok,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Ok value) ok,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Ok value)? ok,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Ok value)? ok,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements MintTransactionsResponse {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
