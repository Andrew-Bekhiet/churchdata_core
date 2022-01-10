// coverage:ignore-file
import 'package:churchdata_core/src/typedefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class PropertyMetadata<T> extends Equatable {
  final String name;
  final String label;
  final T? defaultValue;
  final Query<Json>? collection;

  Type get type => T;

  const PropertyMetadata({
    required this.name,
    required this.label,
    required this.defaultValue,
    this.collection,
  });

  @override
  List<Object?> get props => [
        name,
        label,
        defaultValue,
        collection,
        type,
      ];
}
