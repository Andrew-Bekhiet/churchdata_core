// coverage:ignore-file
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class PermissionsSet extends Equatable {
  static const empty = _EmptyPermissionSet();

  final Set<String> permissions;

  const PermissionsSet.fromSet(this.permissions);

  @override
  List<Object?> get props => permissions.toList();
}

@immutable
class _EmptyPermissionSet extends PermissionsSet {
  const _EmptyPermissionSet() : super.fromSet(const {});
}
