// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_options.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OrderOptionsCWProxy {
  OrderOptions orderBy(String orderBy);

  OrderOptions asc(bool asc);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OrderOptions(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OrderOptions(...).copyWith(id: 12, name: "My name")
  /// ````
  OrderOptions call({
    String? orderBy,
    bool? asc,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOrderOptions.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOrderOptions.copyWith.fieldName(...)`
class _$OrderOptionsCWProxyImpl implements _$OrderOptionsCWProxy {
  const _$OrderOptionsCWProxyImpl(this._value);

  final OrderOptions _value;

  @override
  OrderOptions orderBy(String orderBy) => this(orderBy: orderBy);

  @override
  OrderOptions asc(bool asc) => this(asc: asc);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OrderOptions(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OrderOptions(...).copyWith(id: 12, name: "My name")
  /// ````
  OrderOptions call({
    Object? orderBy = const $CopyWithPlaceholder(),
    Object? asc = const $CopyWithPlaceholder(),
  }) {
    return OrderOptions(
      orderBy: orderBy == const $CopyWithPlaceholder() || orderBy == null
          ? _value.orderBy
          // ignore: cast_nullable_to_non_nullable
          : orderBy as String,
      asc: asc == const $CopyWithPlaceholder() || asc == null
          ? _value.asc
          // ignore: cast_nullable_to_non_nullable
          : asc as bool,
    );
  }
}

extension $OrderOptionsCopyWith on OrderOptions {
  /// Returns a callable class that can be used as follows: `instanceOfOrderOptions.copyWith(...)` or like so:`instanceOfOrderOptions.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$OrderOptionsCWProxy get copyWith => _$OrderOptionsCWProxyImpl(this);
}
