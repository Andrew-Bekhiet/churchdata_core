import 'package:churchdata_core/src/models/bases/id.dart';
import 'package:churchdata_core/src/typedefs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'serializable.dart';

@immutable
abstract class DocumentObject extends Serializable with ID {
  final JsonRef ref;

  @override
  String get id => ref.id;

  const DocumentObject(this.ref);

  const DocumentObject.fromJson(Json json, this.ref);

  DocumentObject.fromJsonDoc(JsonDoc doc)
      : this.fromJson(doc.data()!, doc.reference);

  @override
  List<Object?> get props => [...super.props, ref];

  Future<void> set({Json? merge}) async {
    await ref.set(
      merge ?? toJson(),
      merge != null ? SetOptions(merge: true) : null,
    );
  }

  Future<void> update({Json old = const {}}) async {
    await ref.update(toJson()..removeWhere((key, value) => old[key] == value));
  }
}
