// coverage:ignore-file
import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuditRecord extends DocumentObject {
  static Future<List<AuditRecord>> getAllFromRef(JsonCollectionRef ref) async {
    return (await ref.orderBy('Time', descending: true).limit(1000).get())
        .docs
        .map(AuditRecord.fromJsonDoc)
        .toList();
  }

  const AuditRecord({
    required JsonRef ref,
    required this.time,
    required this.by,
  }) : super(ref);

  AuditRecord.fromJsonDoc(JsonDoc doc)
      : by = doc.data()?['By'],
        time = (doc.data()!['Time'] as Timestamp).toDate(),
        super.fromJsonDoc(doc);

  final DateTime time;
  final String? by;

  @mustCallSuper
  @override
  Json toJson() {
    return {
      'Time': time,
      'By': by,
    };
  }
}
