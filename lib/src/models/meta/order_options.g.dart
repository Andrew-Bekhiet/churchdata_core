// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_options.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$OrderOptionsCWProxy {
  OrderOptions asc(bool asc);

  OrderOptions orderBy(String orderBy);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OrderOptions(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OrderOptions(...).copyWith(id: 12, name: "My name")
  /// ````
  OrderOptions call({
    bool? asc,
    String? orderBy,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfOrderOptions.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfOrderOptions.copyWith.fieldName(...)`
class _$OrderOptionsCWProxyImpl implements _$OrderOptionsCWProxy {
  final OrderOptions _value;

  const _$OrderOptionsCWProxyImpl(this._value);

  @override
  OrderOptions asc(bool asc) => this(asc: asc);

  @override
  OrderOptions orderBy(String orderBy) => this(orderBy: orderBy);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `OrderOptions(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// OrderOptions(...).copyWith(id: 12, name: "My name")
  /// ````
  OrderOptions call({
    Object? asc = const $CopyWithPlaceholder(),
    Object? orderBy = const $CopyWithPlaceholder(),
  }) {
    return OrderOptions(
      asc: asc == const $CopyWithPlaceholder() || asc == null
          ? _value.asc
          // ignore: cast_nullable_to_non_nullable
          : asc as bool,
      orderBy: orderBy == const $CopyWithPlaceholder() || orderBy == null
          ? _value.orderBy
          // ignore: cast_nullable_to_non_nullable
          : orderBy as String,
    );
  }
}

extension $OrderOptionsCopyWith on OrderOptions {
  /// Returns a callable class that can be used as follows: `instanceOfclass OrderOptions extends Equatable.name.copyWith(...)` or like so:`instanceOfclass OrderOptions extends Equatable.name.copyWith.fieldName(...)`.
  _$OrderOptionsCWProxy get copyWith => _$OrderOptionsCWProxyImpl(this);
}
