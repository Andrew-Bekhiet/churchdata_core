import 'package:churchdata_core/churchdata_core.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'user.g.dart';

@immutable
@CopyWith(copyWithNull: true)
class UserBase extends Serializable implements PhotoObjectBase {
  final String uid;
  final String name;
  final String? email;
  final String? phone;
  final PermissionsSet permissions;

  UserBase({
    required this.uid,
    required this.name,
    this.email,
    this.phone,
    this.permissions = PermissionsSet.empty,
  });

  @override
  List<Object?> get props => [uid, name, email, phone, permissions];

  @override
  Json toJson() => {
        'Name': name,
        'Email': email,
        'Phone': phone,
        'Permissions': permissions.permissions
      };

  @override
  IconData get defaultIcon => Icons.account_circle;

  @override
  bool get hasPhoto => true;

  @override
  Reference? get photoRef =>
      GetIt.I<StorageRepository>().ref('UsersPhotos/' + uid);

  @override
  final AsyncMemoizerCache<String> photoUrlCache = AsyncMemoizerCache<String>();
}
