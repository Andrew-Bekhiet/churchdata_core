// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserBaseCWProxy {
  UserBase uid(String uid);

  UserBase name(String name);

  UserBase email(String? email);

  UserBase phone(String? phone);

  UserBase permissions(PermissionsSet permissions);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserBase(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserBase(...).copyWith(id: 12, name: "My name")
  /// ````
  UserBase call({
    String? uid,
    String? name,
    String? email,
    String? phone,
    PermissionsSet? permissions,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserBase.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserBase.copyWith.fieldName(...)`
class _$UserBaseCWProxyImpl implements _$UserBaseCWProxy {
  const _$UserBaseCWProxyImpl(this._value);

  final UserBase _value;

  @override
  UserBase uid(String uid) => this(uid: uid);

  @override
  UserBase name(String name) => this(name: name);

  @override
  UserBase email(String? email) => this(email: email);

  @override
  UserBase phone(String? phone) => this(phone: phone);

  @override
  UserBase permissions(PermissionsSet permissions) =>
      this(permissions: permissions);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserBase(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserBase(...).copyWith(id: 12, name: "My name")
  /// ````
  UserBase call({
    Object? uid = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? permissions = const $CopyWithPlaceholder(),
  }) {
    return UserBase(
      uid: uid == const $CopyWithPlaceholder() || uid == null
          ? _value.uid
          // ignore: cast_nullable_to_non_nullable
          : uid as String,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String?,
      permissions:
          permissions == const $CopyWithPlaceholder() || permissions == null
              ? _value.permissions
              // ignore: cast_nullable_to_non_nullable
              : permissions as PermissionsSet,
    );
  }
}

extension $UserBaseCopyWith on UserBase {
  /// Returns a callable class that can be used as follows: `instanceOfUserBase.copyWith(...)` or like so:`instanceOfUserBase.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$UserBaseCWProxy get copyWith => _$UserBaseCWProxyImpl(this);

  /// Copies the object with the specific fields set to `null`. If you pass `false` as a parameter, nothing will be done and it will be ignored. Don't do it. Prefer `copyWith(field: null)` or `UserBase(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserBase(...).copyWithNull(firstField: true, secondField: true)
  /// ````
  UserBase copyWithNull({
    bool email = false,
    bool phone = false,
  }) {
    return UserBase(
      uid: uid,
      name: name,
      email: email == true ? null : this.email,
      phone: phone == true ? null : this.phone,
      permissions: permissions,
    );
  }
}
