// coverage:ignore-file
import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';

@immutable
abstract class PhotoObjectBase {
  final AsyncMemoizerCache<String> photoUrlCache = AsyncMemoizerCache<String>();

  PhotoObjectBase();
  factory PhotoObjectBase.reference(Reference ref) => SimplePhotoObject(ref);

  IconData get defaultIcon;
  bool get hasPhoto;
  Reference? get photoRef;
}

abstract class DataObjectWithPhoto extends DataObject
    implements PhotoObjectBase {
  DataObjectWithPhoto(super.ref, super.name);
  DataObjectWithPhoto.fromJson(super.data, super.ref) : super.fromJson();
  DataObjectWithPhoto.fromJsonDoc(super.doc) : super.fromJsonDoc();

  @override
  final AsyncMemoizerCache<String> photoUrlCache = AsyncMemoizerCache<String>();
}

class SimplePhotoObject extends PhotoObjectBase {
  SimplePhotoObject(this.photoRef);

  @override
  final Reference photoRef;

  @override
  IconData get defaultIcon => Icons.help;

  @override
  bool get hasPhoto => true;
}
