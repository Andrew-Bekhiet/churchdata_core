import 'package:churchdata_core/churchdata_core.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'user.g.dart';

@immutable
@CopyWith(copyWithNull: true)
class UserBase extends Equatable {
  final String uid;
  final String name;
  final String? email;
  final String? phone;
  final PermissionsSet permissions;

  const UserBase({
    required this.uid,
    required this.name,
    this.email,
    this.phone,
    this.permissions = PermissionsSet.empty,
  });

  @override
  List<Object?> get props => [uid, name, email, phone, permissions];

  Json toJson() => {
        'Name': name,
        'Email': email,
        'Phone': phone,
        'Permissions': permissions.permissions
      };
}
