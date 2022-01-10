// coverage:ignore-file
import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/foundation.dart';

@immutable
class LastEdit extends Serializable {
  final String uid;
  final DateTime time;

  const LastEdit(this.uid, this.time);

  LastEdit.fromJson(Json json) : this(json['UID'], json['Time']?.toDate());

  @override
  Json toJson() => {'UID': uid, 'Time': time};
}
