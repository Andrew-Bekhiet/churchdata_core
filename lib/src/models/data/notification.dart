import 'package:churchdata_core/src/typedefs.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'notification.g.dart';

@immutable
@HiveType(typeId: 0)
class Notification extends Equatable {
  @HiveField(0)
  final String? id;

  @HiveField(1, defaultValue: NotificationType.LocalNotification)
  final NotificationType type;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String body;

  ///Can be image link or object link like: `churchdata.page.link/dx5K2Nm
  @HiveField(4)
  final String? attachmentLink;

  @HiveField(5)
  final DateTime sentTime;

  @HiveField(6)
  final String? senderUID;

  @HiveField(7)
  final Json? additionalData;

  const Notification({
    this.id,
    required this.type,
    required this.title,
    required this.body,
    this.attachmentLink,
    this.senderUID,
    required this.sentTime,
    this.additionalData,
  });

  Notification.fromRemoteMessage(RemoteMessage message)
      : this(
          id: message.messageId,
          type: message.notification == null
              ? NotificationType.DataNotification
              : NotificationType.RemoteNotification,
          body: message.notification?.body ??
              message.data['body'] ??
              message.data['content'],
          title: message.notification?.title ?? message.data['title'],
          sentTime: message.sentTime ?? DateTime.now(),
          senderUID: message.data['senderUID'],
          attachmentLink: message.data['attachment'],
          additionalData: message.data,
        );

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        body,
        attachmentLink,
        sentTime,
        senderUID,
        additionalData,
      ];
}

@HiveType(typeId: 1)
enum NotificationType {
  @HiveField(0)
  // ignore: constant_identifier_names
  DataNotification,
  @HiveField(1)
  // ignore: constant_identifier_names
  RemoteNotification,
  @HiveField(2, defaultValue: true)
  // ignore: constant_identifier_names
  LocalNotification
}
