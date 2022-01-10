import 'package:async/async.dart';
import 'package:churchdata_core/churchdata_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'query_info.g.dart';

///Class represnting Query object
@immutable
@CopyWith(copyWithNull: true)
class QueryInfo with EquatableMixin implements PhotoObjectBase, DataObject {
  final CollectionReference<Json> collection;

  final String fieldPath;
  final String operator;
  final dynamic queryValue;

  final bool order;

  final String? orderBy;
  final bool? descending;

  const QueryInfo({
    required this.collection,
    required this.fieldPath,
    required this.operator,
    this.queryValue,
    required this.order,
    this.orderBy,
    this.descending,
  })  : assert(!order || (orderBy != null && descending != null)),
        assert(
          queryValue == null ||
              queryValue is String ||
              queryValue is int ||
              queryValue is bool ||
              queryValue is JsonRef ||
              queryValue is DateTime,
        );

  QueryInfo.fromJson(Json query)
      : collection =
            GetIt.I<DatabaseRepository>().collection(query['collection']),
        fieldPath = query['fieldPath'] ?? 'Name',
        operator = query['operator'] ?? '=',
        queryValue = query['queryValue'] != null
            ? query['queryValue'].toString().startsWith('B')
                ? query['queryValue'].toString().substring(1) == 'true'
                : query['queryValue'].toString().startsWith('D')
                    ? GetIt.I<DatabaseRepository>()
                        .doc(query['queryValue'].toString().substring(1))
                    : (query['queryValue'].toString().startsWith('T')
                        ? DateTime.fromMillisecondsSinceEpoch(int.parse(
                            query['queryValue'].toString().substring(1)))
                        : (query['queryValue'].toString().startsWith('I')
                            ? int.parse(
                                query['queryValue'].toString().substring(1))
                            : query['queryValue'].toString().substring(1)))
            : null,
        order = query['order'] == 'true',
        orderBy = query['orderBy'] ?? 'Name',
        descending = query['descending'] == 'true';

  @override
  Json toJson() {
    return {
      'collection': collection.id,
      'fieldPath': fieldPath,
      'operator': operator,
      'queryValue': queryValue == null
          ? null
          : queryValue is bool
              ? 'B' + queryValue.toString()
              : queryValue is JsonRef
                  ? 'D' + (queryValue as JsonRef).path
                  : (queryValue is DateTime
                      ? 'T' +
                          (queryValue as DateTime)
                              .millisecondsSinceEpoch
                              .toString()
                      : (queryValue is int
                          ? 'I' + queryValue.toString()
                          : 'S' + queryValue.toString())),
      'order': order.toString(),
      'orderBy': orderBy,
      'descending': descending.toString(),
    };
  }

  // coverage:ignore-start
  @override
  Reference? get photoRef => null;

  @override
  bool get hasPhoto => false;

  @override
  IconData get defaultIcon => Icons.search;

  @override
  AsyncCache<String> get photoUrlCache =>
      AsyncCache<String>(const Duration(days: 1));

  @override
  Future<String?> getSecondLine() async {
    return null;
  }

  @override
  String get id =>
      throw UnsupportedError('`id` is unsupported on Query object');

  @override
  String get name => 'بحث مفصل';

  @override
  List<Object?> get props => toJson().values.toList();

  @override
  JsonRef get ref =>
      throw UnsupportedError('`ref` is unsupported on Query object');

  @override
  Future<void> set({Json? merge}) {
    throw UnsupportedError('`set` is unsupported on Query object');
  }

  @override
  Future<void> update({Json old = const {}}) {
    throw UnsupportedError('`update` is unsupported on Query object');
  }

  @override
  Color? get color => null;

  // coverage:ignore-end
}
