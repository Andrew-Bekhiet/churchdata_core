// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_info.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$QueryInfoCWProxy {
  QueryInfo collection(CollectionReference<Map<String, dynamic>> collection);

  QueryInfo descending(bool? descending);

  QueryInfo fieldPath(String fieldPath);

  QueryInfo operator(String operator);

  QueryInfo order(bool order);

  QueryInfo orderBy(String? orderBy);

  QueryInfo queryValue(dynamic queryValue);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QueryInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QueryInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  QueryInfo call({
    CollectionReference<Map<String, dynamic>>? collection,
    bool? descending,
    String? fieldPath,
    String? operator,
    bool? order,
    String? orderBy,
    dynamic queryValue,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfQueryInfo.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfQueryInfo.copyWith.fieldName(...)`
class _$QueryInfoCWProxyImpl implements _$QueryInfoCWProxy {
  final QueryInfo _value;

  const _$QueryInfoCWProxyImpl(this._value);

  @override
  QueryInfo collection(CollectionReference<Map<String, dynamic>> collection) =>
      this(collection: collection);

  @override
  QueryInfo descending(bool? descending) => this(descending: descending);

  @override
  QueryInfo fieldPath(String fieldPath) => this(fieldPath: fieldPath);

  @override
  QueryInfo operator(String operator) => this(operator: operator);

  @override
  QueryInfo order(bool order) => this(order: order);

  @override
  QueryInfo orderBy(String? orderBy) => this(orderBy: orderBy);

  @override
  QueryInfo queryValue(dynamic queryValue) => this(queryValue: queryValue);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `QueryInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QueryInfo(...).copyWith(id: 12, name: "My name")
  /// ````
  QueryInfo call({
    Object? collection = const $CopyWithPlaceholder(),
    Object? descending = const $CopyWithPlaceholder(),
    Object? fieldPath = const $CopyWithPlaceholder(),
    Object? operator = const $CopyWithPlaceholder(),
    Object? order = const $CopyWithPlaceholder(),
    Object? orderBy = const $CopyWithPlaceholder(),
    Object? queryValue = const $CopyWithPlaceholder(),
  }) {
    return QueryInfo(
      collection: collection == const $CopyWithPlaceholder()
          ? _value.collection
          // ignore: cast_nullable_to_non_nullable
          : collection as CollectionReference<Map<String, dynamic>>,
      descending: descending == const $CopyWithPlaceholder()
          ? _value.descending
          // ignore: cast_nullable_to_non_nullable
          : descending as bool?,
      fieldPath: fieldPath == const $CopyWithPlaceholder()
          ? _value.fieldPath
          // ignore: cast_nullable_to_non_nullable
          : fieldPath as String,
      operator: operator == const $CopyWithPlaceholder()
          ? _value.operator
          // ignore: cast_nullable_to_non_nullable
          : operator as String,
      order: order == const $CopyWithPlaceholder()
          ? _value.order
          // ignore: cast_nullable_to_non_nullable
          : order as bool,
      orderBy: orderBy == const $CopyWithPlaceholder()
          ? _value.orderBy
          // ignore: cast_nullable_to_non_nullable
          : orderBy as String?,
      queryValue: queryValue == const $CopyWithPlaceholder()
          ? _value.queryValue
          // ignore: cast_nullable_to_non_nullable
          : queryValue as dynamic,
    );
  }
}

extension $QueryInfoCopyWith on QueryInfo {
  /// Returns a callable class that can be used as follows: `instanceOfclass QueryInfo with EquatableMixin implements PhotoObjectBase, DataObject.name.copyWith(...)` or like so:`instanceOfclass QueryInfo with EquatableMixin implements PhotoObjectBase, DataObject.name.copyWith.fieldName(...)`.
  _$QueryInfoCWProxy get copyWith => _$QueryInfoCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `QueryInfo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// QueryInfo(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  QueryInfo copyWithNull({
    bool descending = false,
    bool orderBy = false,
  }) {
    return QueryInfo(
      collection: collection,
      descending: descending == true ? null : this.descending,
      fieldPath: fieldPath,
      operator: operator,
      order: order,
      orderBy: orderBy == true ? null : this.orderBy,
      queryValue: queryValue,
    );
  }
}
