// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$UserBaseCWProxy {
  UserBase email(String? email);

  UserBase name(String name);

  UserBase permissions(PermissionsSet permissions);

  UserBase phone(String? phone);

  UserBase uid(String uid);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserBase(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserBase(...).copyWith(id: 12, name: "My name")
  /// ````
  UserBase call({
    String? email,
    String? name,
    PermissionsSet? permissions,
    String? phone,
    String? uid,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfUserBase.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfUserBase.copyWith.fieldName(...)`
class _$UserBaseCWProxyImpl implements _$UserBaseCWProxy {
  final UserBase _value;

  const _$UserBaseCWProxyImpl(this._value);

  @override
  UserBase email(String? email) => this(email: email);

  @override
  UserBase name(String name) => this(name: name);

  @override
  UserBase permissions(PermissionsSet permissions) =>
      this(permissions: permissions);

  @override
  UserBase phone(String? phone) => this(phone: phone);

  @override
  UserBase uid(String uid) => this(uid: uid);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `UserBase(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// UserBase(...).copyWith(id: 12, name: "My name")
  /// ````
  UserBase call({
    Object? email = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? permissions = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? uid = const $CopyWithPlaceholder(),
  }) {
    return UserBase(
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String?,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      permissions: permissions == const $CopyWithPlaceholder()
          ? _value.permissions
          // ignore: cast_nullable_to_non_nullable
          : permissions as PermissionsSet,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String?,
      uid: uid == const $CopyWithPlaceholder()
          ? _value.uid
          // ignore: cast_nullable_to_non_nullable
          : uid as String,
    );
  }
}

extension $UserBaseCopyWith on UserBase {
  /// Returns a callable class that can be used as follows: `instanceOfclass UserBase extends Equatable.name.copyWith(...)` or like so:`instanceOfclass UserBase extends Equatable.name.copyWith.fieldName(...)`.
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
      email: email == true ? null : this.email,
      name: name,
      permissions: permissions,
      phone: phone == true ? null : this.phone,
      uid: uid,
    );
  }
}
