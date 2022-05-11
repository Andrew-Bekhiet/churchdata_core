import 'package:churchdata_core/src/models/bases/viewable.dart';
import 'package:churchdata_core/src/typedefs.dart';
import 'package:flutter/foundation.dart';

import 'document_object.dart';

@immutable
abstract class DataObject extends DocumentObject with Viewable {
  @override
  final String name;

  const DataObject(super.ref, this.name);

  DataObject.fromJson(super.data, super.ref)
      : name = data['Name'] ?? '',
        super.fromJson();

  DataObject.fromJsonDoc(JsonDoc doc)
      : this.fromJson(doc.data()!, doc.reference);
}
