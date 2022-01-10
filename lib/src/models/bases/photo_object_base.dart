// coverage:ignore-file
import 'package:async/async.dart';
import 'package:churchdata_core/src/typedefs.dart';
import 'package:flutter/material.dart';

@immutable
abstract class PhotoObjectBase {
  final IconData defaultIcon;
  final bool hasPhoto;

  final AsyncCache<String> photoUrlCache =
      AsyncCache<String>(const Duration(days: 1));

  PhotoObjectBase(this.defaultIcon, this.hasPhoto);

  factory PhotoObjectBase.reference(Reference ref) => SimplePhotoObject(ref);

  Reference? get photoRef;
}

class SimplePhotoObject extends PhotoObjectBase {
  SimplePhotoObject(this.photoRef) : super(Icons.help, true);

  @override
  final Reference photoRef;
}
