import 'package:flutter/material.dart';

@immutable
abstract class Viewable {
  String get name;
  Color? get color => null;
  Future<String?> getSecondLine() async => null;
}
