// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'candy_machine_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CandyMachineData {
  CandyMachineCoupon? get selectedCoupon => throw _privateConstructorUsedError;
  CouponCurrencySetting? get selectedCurrency =>
      throw _privateConstructorUsedError;
  int get numberOfItems => throw _privateConstructorUsedError;

  /// Create a copy of CandyMachineData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CandyMachineDataCopyWith<CandyMachineData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CandyMachineDataCopyWith<$Res> {
  factory $CandyMachineDataCopyWith(
          CandyMachineData value, $Res Function(CandyMachineData) then) =
      _$CandyMachineDataCopyWithImpl<$Res, CandyMachineData>;
  @useResult
  $Res call(
      {CandyMachineCoupon? selectedCoupon,
      CouponCurrencySetting? selectedCurrency,
      int numberOfItems});
}

/// @nodoc
class _$CandyMachineDataCopyWithImpl<$Res, $Val extends CandyMachineData>
    implements $CandyMachineDataCopyWith<$Res> {
  _$CandyMachineDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CandyMachineData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedCoupon = freezed,
    Object? selectedCurrency = freezed,
    Object? numberOfItems = null,
  }) {
    return _then(_value.copyWith(
      selectedCoupon: freezed == selectedCoupon
          ? _value.selectedCoupon
          : selectedCoupon // ignore: cast_nullable_to_non_nullable
              as CandyMachineCoupon?,
      selectedCurrency: freezed == selectedCurrency
          ? _value.selectedCurrency
          : selectedCurrency // ignore: cast_nullable_to_non_nullable
              as CouponCurrencySetting?,
      numberOfItems: null == numberOfItems
          ? _value.numberOfItems
          : numberOfItems // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CandyMachineDataImplCopyWith<$Res>
    implements $CandyMachineDataCopyWith<$Res> {
  factory _$$CandyMachineDataImplCopyWith(_$CandyMachineDataImpl value,
          $Res Function(_$CandyMachineDataImpl) then) =
      __$$CandyMachineDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CandyMachineCoupon? selectedCoupon,
      CouponCurrencySetting? selectedCurrency,
      int numberOfItems});
}

/// @nodoc
class __$$CandyMachineDataImplCopyWithImpl<$Res>
    extends _$CandyMachineDataCopyWithImpl<$Res, _$CandyMachineDataImpl>
    implements _$$CandyMachineDataImplCopyWith<$Res> {
  __$$CandyMachineDataImplCopyWithImpl(_$CandyMachineDataImpl _value,
      $Res Function(_$CandyMachineDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of CandyMachineData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedCoupon = freezed,
    Object? selectedCurrency = freezed,
    Object? numberOfItems = null,
  }) {
    return _then(_$CandyMachineDataImpl(
      selectedCoupon: freezed == selectedCoupon
          ? _value.selectedCoupon
          : selectedCoupon // ignore: cast_nullable_to_non_nullable
              as CandyMachineCoupon?,
      selectedCurrency: freezed == selectedCurrency
          ? _value.selectedCurrency
          : selectedCurrency // ignore: cast_nullable_to_non_nullable
              as CouponCurrencySetting?,
      numberOfItems: null == numberOfItems
          ? _value.numberOfItems
          : numberOfItems // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$CandyMachineDataImpl implements _CandyMachineData {
  const _$CandyMachineDataImpl(
      {this.selectedCoupon, this.selectedCurrency, this.numberOfItems = 1});

  @override
  final CandyMachineCoupon? selectedCoupon;
  @override
  final CouponCurrencySetting? selectedCurrency;
  @override
  @JsonKey()
  final int numberOfItems;

  @override
  String toString() {
    return 'CandyMachineData(selectedCoupon: $selectedCoupon, selectedCurrency: $selectedCurrency, numberOfItems: $numberOfItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CandyMachineDataImpl &&
            (identical(other.selectedCoupon, selectedCoupon) ||
                other.selectedCoupon == selectedCoupon) &&
            (identical(other.selectedCurrency, selectedCurrency) ||
                other.selectedCurrency == selectedCurrency) &&
            (identical(other.numberOfItems, numberOfItems) ||
                other.numberOfItems == numberOfItems));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, selectedCoupon, selectedCurrency, numberOfItems);

  /// Create a copy of CandyMachineData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CandyMachineDataImplCopyWith<_$CandyMachineDataImpl> get copyWith =>
      __$$CandyMachineDataImplCopyWithImpl<_$CandyMachineDataImpl>(
          this, _$identity);
}

abstract class _CandyMachineData implements CandyMachineData {
  const factory _CandyMachineData(
      {final CandyMachineCoupon? selectedCoupon,
      final CouponCurrencySetting? selectedCurrency,
      final int numberOfItems}) = _$CandyMachineDataImpl;

  @override
  CandyMachineCoupon? get selectedCoupon;
  @override
  CouponCurrencySetting? get selectedCurrency;
  @override
  int get numberOfItems;

  /// Create a copy of CandyMachineData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CandyMachineDataImplCopyWith<_$CandyMachineDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
