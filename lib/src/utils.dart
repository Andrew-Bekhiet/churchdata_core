import 'dart:async';

import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeago/timeago.dart';

String formatPhone(String phone, [bool forWhatsapp = true]) {
  if (phone.startsWith('+')) return phone.replaceFirst('+', '').trim();
  if (phone.startsWith('2')) return phone.trim();
  if (phone.startsWith('0') && forWhatsapp) return '2' + phone.trim();
  if (phone.startsWith('1') && forWhatsapp) return '20' + phone.trim();
  return phone.trim();
}

///Gets the rise day date for the specified [year]
DateTime getRiseDay([int? year]) {
  year ??= DateTime.now().year;
  final int a = year % 4;
  final int b = year % 7;
  final int c = year % 19;
  final int d = (19 * c + 15) % 30;
  final int e = (2 * a + 4 * b - d + 34) % 7;

  return DateTime(year, (d + e + 114) ~/ 31, ((d + e + 114) % 31) + 14);
}

bool isSubtype<Generic, Subtype>() => <Subtype>[] is List<Generic>;

// coverage:ignore-start
extension DateTimeX on DateTime {
  Timestamp toTimestamp() => Timestamp.fromDate(this);

  String toDurationString({bool appendSince = true}) {
    if (appendSince) return format(this, locale: 'ar');
    return format(this, locale: 'ar').replaceAll('منذ ', '');
  }

  DateTime truncateToDay() {
    return DateTime(year, month, day);
  }

  DateTime truncateToUTCDay() {
    return DateTime.utc(year, month, day);
  }

  DateTime replaceTimeOfDay(TimeOfDay time) {
    return DateTime(
      year,
      month,
      day,
      time.hour,
      time.minute,
      second,
      millisecond,
      microsecond,
    );
  }

  DateTime replaceTime(DateTime time) {
    return DateTime(
      year,
      month,
      day,
      time.hour,
      time.minute,
      time.second,
      time.millisecond,
      time.microsecond,
    );
  }

  DateTime replaceDate(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }
}
// coverage:ignore-end

extension NextItem<T> on Stream<T> {
  ///Awaits until another next element is emitted
  ///and returns it
  Future<T> get next {
    final completer = Completer<T>();
    final subscription = listen((_) {}, onError: (_) {});

    subscription
      ..onData((data) async {
        await subscription.cancel();
        completer.complete(data);
      })
      ..onError((data) async {
        await subscription.cancel();
        completer.completeError(data);
      });

    return completer.future;
  }
}

extension SplitList<T> on List<T> {
  List<List<T>> split(int listLength) {
    final List<List<T>> chunks = [];
    for (int i = 0; i < length; i += listLength) {
      chunks.add(sublist(i, i + listLength > length ? length : i + listLength));
    }
    return chunks;
  }
}

// coverage:ignore-start
extension BoolComparison on bool? {
  int compareTo(bool? o) {
    if (this == o) return 0;
    // ignore: use_if_null_to_convert_nulls_to_bools
    if (this == true) return -1;
    if (this == false) {
      // ignore: use_if_null_to_convert_nulls_to_bools
      if (o == true) return 1;
      return -1;
    }
    return 1;
  }
}

extension LatLngToGeoPoint on LatLng {
  GeoPoint toGeoPoint() {
    return GeoPoint(latitude, longitude);
  }
}

extension GeoPointLatLng on GeoPoint {
  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}
// coverage:ignore-end
