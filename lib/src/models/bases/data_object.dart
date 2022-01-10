import 'dart:ui';

import 'package:churchdata_core/src/typedefs.dart';
import 'package:flutter/foundation.dart';

import 'document_object.dart';

@immutable
abstract class DataObject extends DocumentObject {
  final String name;

  const DataObject(JsonRef ref, this.name) : super(ref);

  DataObject.fromJson(Json data, JsonRef ref)
      : name = data['Name'] ?? '',
        super.fromJson(data, ref);

  DataObject.fromJsonDoc(JsonDoc doc)
      : this.fromJson(doc.data()!, doc.reference);

  Color? get color => null;

  Future<String?> getSecondLine() async => null;
}
