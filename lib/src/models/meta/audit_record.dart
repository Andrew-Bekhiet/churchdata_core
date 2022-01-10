// coverage:ignore-file
import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/foundation.dart';

@immutable
class AuditRecord extends DocumentObject {
  const AuditRecord({
    required JsonRef ref,
    required this.time,
    required this.by,
  }) : super(ref);

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
