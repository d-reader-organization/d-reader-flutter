// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PaginationState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<T> items) data,
    required TResult Function() loading,
    required TResult Function(Object? e, StackTrace? stk) error,
    required TResult Function(List<T> items) onGoingLoading,
    required TResult Function(List<T> items, Object? e, StackTrace? stk)
        onGoingError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<T> items)? data,
    TResult? Function()? loading,
    TResult? Function(Object? e, StackTrace? stk)? error,
    TResult? Function(List<T> items)? onGoingLoading,
    TResult? Function(List<T> items, Object? e, StackTrace? stk)? onGoingError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<T> items)? data,
    TResult Function()? loading,
    TResult Function(Object? e, StackTrace? stk)? error,
    TResult Function(List<T> items)? onGoingLoading,
    TResult Function(List<T> items, Object? e, StackTrace? stk)? onGoingError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Data<T> value) data,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_Error<T> value) error,
    required TResult Function(_OnGoingLoading<T> value) onGoingLoading,
    required TResult Function(_OnGoingError<T> value) onGoingError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Data<T> value)? data,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_Error<T> value)? error,
    TResult? Function(_OnGoingLoading<T> value)? onGoingLoading,
    TResult? Function(_OnGoingError<T> value)? onGoingError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data<T> value)? data,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_Error<T> value)? error,
    TResult Function(_OnGoingLoading<T> value)? onGoingLoading,
    TResult Function(_OnGoingError<T> value)? onGoingError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginationStateCopyWith<T, $Res> {
  factory $PaginationStateCopyWith(
          PaginationState<T> value, $Res Function(PaginationState<T>) then) =
      _$PaginationStateCopyWithImpl<T, $Res, PaginationState<T>>;
}

/// @nodoc
class _$PaginationStateCopyWithImpl<T, $Res, $Val extends PaginationState<T>>
    implements $PaginationStateCopyWith<T, $Res> {
  _$PaginationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$DataImplCopyWith<T, $Res> {
  factory _$$DataImplCopyWith(
          _$DataImpl<T> value, $Res Function(_$DataImpl<T>) then) =
      __$$DataImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({List<T> items});
}

/// @nodoc
class __$$DataImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$DataImpl<T>>
    implements _$$DataImplCopyWith<T, $Res> {
  __$$DataImplCopyWithImpl(
      _$DataImpl<T> _value, $Res Function(_$DataImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_$DataImpl<T>(
      null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ));
  }
}

/// @nodoc

class _$DataImpl<T> implements _Data<T> {
  const _$DataImpl(final List<T> items) : _items = items;

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PaginationState<$T>.data(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DataImplCopyWith<T, _$DataImpl<T>> get copyWith =>
      __$$DataImplCopyWithImpl<T, _$DataImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<T> items) data,
    required TResult Function() loading,
    required TResult Function(Object? e, StackTrace? stk) error,
    required TResult Function(List<T> items) onGoingLoading,
    required TResult Function(List<T> items, Object? e, StackTrace? stk)
        onGoingError,
  }) {
    return data(items);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<T> items)? data,
    TResult? Function()? loading,
    TResult? Function(Object? e, StackTrace? stk)? error,
    TResult? Function(List<T> items)? onGoingLoading,
    TResult? Function(List<T> items, Object? e, StackTrace? stk)? onGoingError,
  }) {
    return data?.call(items);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<T> items)? data,
    TResult Function()? loading,
    TResult Function(Object? e, StackTrace? stk)? error,
    TResult Function(List<T> items)? onGoingLoading,
    TResult Function(List<T> items, Object? e, StackTrace? stk)? onGoingError,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(items);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Data<T> value) data,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_Error<T> value) error,
    required TResult Function(_OnGoingLoading<T> value) onGoingLoading,
    required TResult Function(_OnGoingError<T> value) onGoingError,
  }) {
    return data(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Data<T> value)? data,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_Error<T> value)? error,
    TResult? Function(_OnGoingLoading<T> value)? onGoingLoading,
    TResult? Function(_OnGoingError<T> value)? onGoingError,
  }) {
    return data?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data<T> value)? data,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_Error<T> value)? error,
    TResult Function(_OnGoingLoading<T> value)? onGoingLoading,
    TResult Function(_OnGoingError<T> value)? onGoingError,
    required TResult orElse(),
  }) {
    if (data != null) {
      return data(this);
    }
    return orElse();
  }
}

abstract class _Data<T> implements PaginationState<T> {
  const factory _Data(final List<T> items) = _$DataImpl<T>;

  List<T> get items;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DataImplCopyWith<T, _$DataImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<T, $Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl<T> value, $Res Function(_$LoadingImpl<T>) then) =
      __$$LoadingImplCopyWithImpl<T, $Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$LoadingImpl<T>>
    implements _$$LoadingImplCopyWith<T, $Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl<T> _value, $Res Function(_$LoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl<T> implements _Loading<T> {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'PaginationState<$T>.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl<T>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<T> items) data,
    required TResult Function() loading,
    required TResult Function(Object? e, StackTrace? stk) error,
    required TResult Function(List<T> items) onGoingLoading,
    required TResult Function(List<T> items, Object? e, StackTrace? stk)
        onGoingError,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<T> items)? data,
    TResult? Function()? loading,
    TResult? Function(Object? e, StackTrace? stk)? error,
    TResult? Function(List<T> items)? onGoingLoading,
    TResult? Function(List<T> items, Object? e, StackTrace? stk)? onGoingError,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<T> items)? data,
    TResult Function()? loading,
    TResult Function(Object? e, StackTrace? stk)? error,
    TResult Function(List<T> items)? onGoingLoading,
    TResult Function(List<T> items, Object? e, StackTrace? stk)? onGoingError,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Data<T> value) data,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_Error<T> value) error,
    required TResult Function(_OnGoingLoading<T> value) onGoingLoading,
    required TResult Function(_OnGoingError<T> value) onGoingError,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Data<T> value)? data,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_Error<T> value)? error,
    TResult? Function(_OnGoingLoading<T> value)? onGoingLoading,
    TResult? Function(_OnGoingError<T> value)? onGoingError,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data<T> value)? data,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_Error<T> value)? error,
    TResult Function(_OnGoingLoading<T> value)? onGoingLoading,
    TResult Function(_OnGoingError<T> value)? onGoingError,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading<T> implements PaginationState<T> {
  const factory _Loading() = _$LoadingImpl<T>;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<T, $Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl<T> value, $Res Function(_$ErrorImpl<T>) then) =
      __$$ErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({Object? e, StackTrace? stk});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$ErrorImpl<T>>
    implements _$$ErrorImplCopyWith<T, $Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl<T> _value, $Res Function(_$ErrorImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? e = freezed,
    Object? stk = freezed,
  }) {
    return _then(_$ErrorImpl<T>(
      freezed == e ? _value.e : e,
      freezed == stk
          ? _value.stk
          : stk // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class _$ErrorImpl<T> implements _Error<T> {
  const _$ErrorImpl(this.e, [this.stk]);

  @override
  final Object? e;
  @override
  final StackTrace? stk;

  @override
  String toString() {
    return 'PaginationState<$T>.error(e: $e, stk: $stk)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl<T> &&
            const DeepCollectionEquality().equals(other.e, e) &&
            (identical(other.stk, stk) || other.stk == stk));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(e), stk);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<T, _$ErrorImpl<T>> get copyWith =>
      __$$ErrorImplCopyWithImpl<T, _$ErrorImpl<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<T> items) data,
    required TResult Function() loading,
    required TResult Function(Object? e, StackTrace? stk) error,
    required TResult Function(List<T> items) onGoingLoading,
    required TResult Function(List<T> items, Object? e, StackTrace? stk)
        onGoingError,
  }) {
    return error(e, stk);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<T> items)? data,
    TResult? Function()? loading,
    TResult? Function(Object? e, StackTrace? stk)? error,
    TResult? Function(List<T> items)? onGoingLoading,
    TResult? Function(List<T> items, Object? e, StackTrace? stk)? onGoingError,
  }) {
    return error?.call(e, stk);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<T> items)? data,
    TResult Function()? loading,
    TResult Function(Object? e, StackTrace? stk)? error,
    TResult Function(List<T> items)? onGoingLoading,
    TResult Function(List<T> items, Object? e, StackTrace? stk)? onGoingError,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(e, stk);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Data<T> value) data,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_Error<T> value) error,
    required TResult Function(_OnGoingLoading<T> value) onGoingLoading,
    required TResult Function(_OnGoingError<T> value) onGoingError,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Data<T> value)? data,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_Error<T> value)? error,
    TResult? Function(_OnGoingLoading<T> value)? onGoingLoading,
    TResult? Function(_OnGoingError<T> value)? onGoingError,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data<T> value)? data,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_Error<T> value)? error,
    TResult Function(_OnGoingLoading<T> value)? onGoingLoading,
    TResult Function(_OnGoingError<T> value)? onGoingError,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error<T> implements PaginationState<T> {
  const factory _Error(final Object? e, [final StackTrace? stk]) =
      _$ErrorImpl<T>;

  Object? get e;
  StackTrace? get stk;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<T, _$ErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnGoingLoadingImplCopyWith<T, $Res> {
  factory _$$OnGoingLoadingImplCopyWith(_$OnGoingLoadingImpl<T> value,
          $Res Function(_$OnGoingLoadingImpl<T>) then) =
      __$$OnGoingLoadingImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({List<T> items});
}

/// @nodoc
class __$$OnGoingLoadingImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$OnGoingLoadingImpl<T>>
    implements _$$OnGoingLoadingImplCopyWith<T, $Res> {
  __$$OnGoingLoadingImplCopyWithImpl(_$OnGoingLoadingImpl<T> _value,
      $Res Function(_$OnGoingLoadingImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_$OnGoingLoadingImpl<T>(
      null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
    ));
  }
}

/// @nodoc

class _$OnGoingLoadingImpl<T> implements _OnGoingLoading<T> {
  const _$OnGoingLoadingImpl(final List<T> items) : _items = items;

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'PaginationState<$T>.onGoingLoading(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnGoingLoadingImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnGoingLoadingImplCopyWith<T, _$OnGoingLoadingImpl<T>> get copyWith =>
      __$$OnGoingLoadingImplCopyWithImpl<T, _$OnGoingLoadingImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<T> items) data,
    required TResult Function() loading,
    required TResult Function(Object? e, StackTrace? stk) error,
    required TResult Function(List<T> items) onGoingLoading,
    required TResult Function(List<T> items, Object? e, StackTrace? stk)
        onGoingError,
  }) {
    return onGoingLoading(items);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<T> items)? data,
    TResult? Function()? loading,
    TResult? Function(Object? e, StackTrace? stk)? error,
    TResult? Function(List<T> items)? onGoingLoading,
    TResult? Function(List<T> items, Object? e, StackTrace? stk)? onGoingError,
  }) {
    return onGoingLoading?.call(items);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<T> items)? data,
    TResult Function()? loading,
    TResult Function(Object? e, StackTrace? stk)? error,
    TResult Function(List<T> items)? onGoingLoading,
    TResult Function(List<T> items, Object? e, StackTrace? stk)? onGoingError,
    required TResult orElse(),
  }) {
    if (onGoingLoading != null) {
      return onGoingLoading(items);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Data<T> value) data,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_Error<T> value) error,
    required TResult Function(_OnGoingLoading<T> value) onGoingLoading,
    required TResult Function(_OnGoingError<T> value) onGoingError,
  }) {
    return onGoingLoading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Data<T> value)? data,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_Error<T> value)? error,
    TResult? Function(_OnGoingLoading<T> value)? onGoingLoading,
    TResult? Function(_OnGoingError<T> value)? onGoingError,
  }) {
    return onGoingLoading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data<T> value)? data,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_Error<T> value)? error,
    TResult Function(_OnGoingLoading<T> value)? onGoingLoading,
    TResult Function(_OnGoingError<T> value)? onGoingError,
    required TResult orElse(),
  }) {
    if (onGoingLoading != null) {
      return onGoingLoading(this);
    }
    return orElse();
  }
}

abstract class _OnGoingLoading<T> implements PaginationState<T> {
  const factory _OnGoingLoading(final List<T> items) = _$OnGoingLoadingImpl<T>;

  List<T> get items;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnGoingLoadingImplCopyWith<T, _$OnGoingLoadingImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnGoingErrorImplCopyWith<T, $Res> {
  factory _$$OnGoingErrorImplCopyWith(_$OnGoingErrorImpl<T> value,
          $Res Function(_$OnGoingErrorImpl<T>) then) =
      __$$OnGoingErrorImplCopyWithImpl<T, $Res>;
  @useResult
  $Res call({List<T> items, Object? e, StackTrace? stk});
}

/// @nodoc
class __$$OnGoingErrorImplCopyWithImpl<T, $Res>
    extends _$PaginationStateCopyWithImpl<T, $Res, _$OnGoingErrorImpl<T>>
    implements _$$OnGoingErrorImplCopyWith<T, $Res> {
  __$$OnGoingErrorImplCopyWithImpl(
      _$OnGoingErrorImpl<T> _value, $Res Function(_$OnGoingErrorImpl<T>) _then)
      : super(_value, _then);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? e = freezed,
    Object? stk = freezed,
  }) {
    return _then(_$OnGoingErrorImpl<T>(
      null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<T>,
      freezed == e ? _value.e : e,
      freezed == stk
          ? _value.stk
          : stk // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class _$OnGoingErrorImpl<T> implements _OnGoingError<T> {
  const _$OnGoingErrorImpl(final List<T> items, this.e, [this.stk])
      : _items = items;

  final List<T> _items;
  @override
  List<T> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final Object? e;
  @override
  final StackTrace? stk;

  @override
  String toString() {
    return 'PaginationState<$T>.onGoingError(items: $items, e: $e, stk: $stk)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnGoingErrorImpl<T> &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality().equals(other.e, e) &&
            (identical(other.stk, stk) || other.stk == stk));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(e),
      stk);

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnGoingErrorImplCopyWith<T, _$OnGoingErrorImpl<T>> get copyWith =>
      __$$OnGoingErrorImplCopyWithImpl<T, _$OnGoingErrorImpl<T>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(List<T> items) data,
    required TResult Function() loading,
    required TResult Function(Object? e, StackTrace? stk) error,
    required TResult Function(List<T> items) onGoingLoading,
    required TResult Function(List<T> items, Object? e, StackTrace? stk)
        onGoingError,
  }) {
    return onGoingError(items, e, stk);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(List<T> items)? data,
    TResult? Function()? loading,
    TResult? Function(Object? e, StackTrace? stk)? error,
    TResult? Function(List<T> items)? onGoingLoading,
    TResult? Function(List<T> items, Object? e, StackTrace? stk)? onGoingError,
  }) {
    return onGoingError?.call(items, e, stk);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(List<T> items)? data,
    TResult Function()? loading,
    TResult Function(Object? e, StackTrace? stk)? error,
    TResult Function(List<T> items)? onGoingLoading,
    TResult Function(List<T> items, Object? e, StackTrace? stk)? onGoingError,
    required TResult orElse(),
  }) {
    if (onGoingError != null) {
      return onGoingError(items, e, stk);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Data<T> value) data,
    required TResult Function(_Loading<T> value) loading,
    required TResult Function(_Error<T> value) error,
    required TResult Function(_OnGoingLoading<T> value) onGoingLoading,
    required TResult Function(_OnGoingError<T> value) onGoingError,
  }) {
    return onGoingError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Data<T> value)? data,
    TResult? Function(_Loading<T> value)? loading,
    TResult? Function(_Error<T> value)? error,
    TResult? Function(_OnGoingLoading<T> value)? onGoingLoading,
    TResult? Function(_OnGoingError<T> value)? onGoingError,
  }) {
    return onGoingError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Data<T> value)? data,
    TResult Function(_Loading<T> value)? loading,
    TResult Function(_Error<T> value)? error,
    TResult Function(_OnGoingLoading<T> value)? onGoingLoading,
    TResult Function(_OnGoingError<T> value)? onGoingError,
    required TResult orElse(),
  }) {
    if (onGoingError != null) {
      return onGoingError(this);
    }
    return orElse();
  }
}

abstract class _OnGoingError<T> implements PaginationState<T> {
  const factory _OnGoingError(final List<T> items, final Object? e,
      [final StackTrace? stk]) = _$OnGoingErrorImpl<T>;

  List<T> get items;
  Object? get e;
  StackTrace? get stk;

  /// Create a copy of PaginationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnGoingErrorImplCopyWith<T, _$OnGoingErrorImpl<T>> get copyWith =>
      throw _privateConstructorUsedError;
}
