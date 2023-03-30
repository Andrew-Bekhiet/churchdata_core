// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_info.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$QueryInfoCWProxy {
  QueryInfo collection(CollectionReference<Map<String, dynamic>> collection);

  QueryInfo fieldPath(String fieldPath);

  QueryInfo operator(String operator);

  QueryInfo queryValue(Object? queryValue);

  QueryInfo order(bool order);

  QueryInfo orderBy(String? orderBy);

  QueryInfo descending(bool? descending);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QueryInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QueryInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  QueryInfo call({
    CollectionReference<Map<String, dynamic>>? collection,
    String? fieldPath,
    String? operator,
    Object? queryValue,
    bool? order,
    String? orderBy,
    bool? descending,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfQueryInfo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfQueryInfo.copyWith.fieldName(...)`
class _$QueryInfoCWProxyImpl implements _$QueryInfoCWProxy {
  const _$QueryInfoCWProxyImpl(this._value);

  final QueryInfo _value;

  @override
  QueryInfo collection(CollectionReference<Map<String, dynamic>> collection) =>
      this(collection: collection);

  @override
  QueryInfo fieldPath(String fieldPath) => this(fieldPath: fieldPath);

  @override
  QueryInfo operator(String operator) => this(operator: operator);

  @override
  QueryInfo queryValue(Object? queryValue) => this(queryValue: queryValue);

  @override
  QueryInfo order(bool order) => this(order: order);

  @override
  QueryInfo orderBy(String? orderBy) => this(orderBy: orderBy);

  @override
  QueryInfo descending(bool? descending) => this(descending: descending);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QueryInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QueryInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  QueryInfo call({
    Object? collection = const $CopyWithPlaceholder(),
    Object? fieldPath = const $CopyWithPlaceholder(),
    Object? operator = const $CopyWithPlaceholder(),
    Object? queryValue = const $CopyWithPlaceholder(),
    Object? order = const $CopyWithPlaceholder(),
    Object? orderBy = const $CopyWithPlaceholder(),
    Object? descending = const $CopyWithPlaceholder(),
  }) {
    return QueryInfo(
      collection:
          collection == const $CopyWithPlaceholder() || collection == null
              ? _value.collection
              // ignore: cast_nullable_to_non_nullable
              : collection as CollectionReference<Map<String, dynamic>>,
      fieldPath: fieldPath == const $CopyWithPlaceholder() || fieldPath == null
          ? _value.fieldPath
          // ignore: cast_nullable_to_non_nullable
          : fieldPath as String,
      operator: operator == const $CopyWithPlaceholder() || operator == null
          ? _value.operator
          // ignore: cast_nullable_to_non_nullable
          : operator as String,
      queryValue: queryValue == const $CopyWithPlaceholder()
          ? _value.queryValue
          // ignore: cast_nullable_to_non_nullable
          : queryValue as Object?,
      order: order == const $CopyWithPlaceholder() || order == null
          ? _value.order
          // ignore: cast_nullable_to_non_nullable
          : order as bool,
      orderBy: orderBy == const $CopyWithPlaceholder()
          ? _value.orderBy
          // ignore: cast_nullable_to_non_nullable
          : orderBy as String?,
      descending: descending == const $CopyWithPlaceholder()
          ? _value.descending
          // ignore: cast_nullable_to_non_nullable
          : descending as bool?,
    );
  }
}

extension $QueryInfoCopyWith on QueryInfo {
  /// Returns a callable class that can be used as follows: `instanceOfQueryInfo.copyWith(...)` or like so:`instanceOfQueryInfo.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$QueryInfoCWProxy get copyWith => _$QueryInfoCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `QueryInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QueryInfo(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  QueryInfo copyWithNull({
    bool queryValue = false,
    bool orderBy = false,
    bool descending = false,
  }) {
    return QueryInfo(
      collection: collection,
      fieldPath: fieldPath,
      operator: operator,
      queryValue: queryValue == true ? null : this.queryValue,
      order: order,
      orderBy: orderBy == true ? null : this.orderBy,
      descending: descending == true ? null : this.descending,
    );
  }
}
