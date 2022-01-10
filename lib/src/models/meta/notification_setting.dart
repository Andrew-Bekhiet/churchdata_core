import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'notification_setting.g.dart';

@immutable
@HiveType(typeId: 2)
class NotificationSetting extends Equatable {
  @HiveField(0)
  final int hours;
  @HiveField(1)
  final int minutes;
  @HiveField(2)
  final int intervalInDays;

  const NotificationSetting(this.hours, this.minutes, this.intervalInDays);

  @override
  List<Object?> get props => [
        hours,
        minutes,
        intervalInDays,
      ];
}
