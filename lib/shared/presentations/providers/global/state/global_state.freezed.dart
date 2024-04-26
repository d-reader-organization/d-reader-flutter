// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'global_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GlobalState {
  bool get isLoading => throw _privateConstructorUsedError;
  String get signatureMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GlobalStateCopyWith<GlobalState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GlobalStateCopyWith<$Res> {
  factory $GlobalStateCopyWith(
          GlobalState value, $Res Function(GlobalState) then) =
      _$GlobalStateCopyWithImpl<$Res, GlobalState>;
  @useResult
  $Res call({bool isLoading, String signatureMessage});
}

/// @nodoc
class _$GlobalStateCopyWithImpl<$Res, $Val extends GlobalState>
    implements $GlobalStateCopyWith<$Res> {
  _$GlobalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? signatureMessage = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      signatureMessage: null == signatureMessage
          ? _value.signatureMessage
          : signatureMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GlobalStateImplCopyWith<$Res>
    implements $GlobalStateCopyWith<$Res> {
  factory _$$GlobalStateImplCopyWith(
          _$GlobalStateImpl value, $Res Function(_$GlobalStateImpl) then) =
      __$$GlobalStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, String signatureMessage});
}

/// @nodoc
class __$$GlobalStateImplCopyWithImpl<$Res>
    extends _$GlobalStateCopyWithImpl<$Res, _$GlobalStateImpl>
    implements _$$GlobalStateImplCopyWith<$Res> {
  __$$GlobalStateImplCopyWithImpl(
      _$GlobalStateImpl _value, $Res Function(_$GlobalStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? signatureMessage = null,
  }) {
    return _then(_$GlobalStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      signatureMessage: null == signatureMessage
          ? _value.signatureMessage
          : signatureMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GlobalStateImpl implements _GlobalState {
  const _$GlobalStateImpl(
      {required this.isLoading, this.signatureMessage = ''});

  @override
  final bool isLoading;
  @override
  @JsonKey()
  final String signatureMessage;

  @override
  String toString() {
    return 'GlobalState(isLoading: $isLoading, signatureMessage: $signatureMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GlobalStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.signatureMessage, signatureMessage) ||
                other.signatureMessage == signatureMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, signatureMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GlobalStateImplCopyWith<_$GlobalStateImpl> get copyWith =>
      __$$GlobalStateImplCopyWithImpl<_$GlobalStateImpl>(this, _$identity);
}

abstract class _GlobalState implements GlobalState {
  const factory _GlobalState(
      {required final bool isLoading,
      final String signatureMessage}) = _$GlobalStateImpl;

  @override
  bool get isLoading;
  @override
  String get signatureMessage;
  @override
  @JsonKey(ignore: true)
  _$$GlobalStateImplCopyWith<_$GlobalStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
