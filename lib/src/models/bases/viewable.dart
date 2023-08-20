import 'package:churchdata_core/src/models/bases/id.dart';
import 'package:flutter/material.dart';

@immutable
abstract mixin class Viewable {
  String get name;
  Color? get color => null;
  Future<String?> getSecondLine() async => null;
}

@immutable
abstract class ViewableWithID implements Viewable, ID {
  @override
  String get name;
  @override
  Color? get color => null;
  @override
  Future<String?> getSecondLine() async => null;
}
