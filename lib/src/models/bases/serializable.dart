// coverage:ignore-file
import 'package:churchdata_core/src/typedefs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class Serializable extends Equatable {
  const Serializable();

  @override
  List<Object?> get props => toJson().values.toList();

  Json toJson();
}
