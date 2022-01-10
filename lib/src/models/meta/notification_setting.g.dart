// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_setting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationSettingAdapter extends TypeAdapter<NotificationSetting> {
  @override
  final int typeId = 2;

  @override
  NotificationSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationSetting(
      fields[0] as int,
      fields[1] as int,
      fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationSetting obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.hours)
      ..writeByte(1)
      ..write(obj.minutes)
      ..writeByte(2)
      ..write(obj.intervalInDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
