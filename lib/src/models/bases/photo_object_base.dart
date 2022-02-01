// coverage:ignore-file
import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';

@immutable
abstract class PhotoObjectBase {
  final IconData defaultIcon;
  final bool hasPhoto;

  final AsyncMemoizerCache<String> photoUrlCache = AsyncMemoizerCache<String>();

  PhotoObjectBase(this.defaultIcon, this.hasPhoto);

  factory PhotoObjectBase.reference(Reference ref) => SimplePhotoObject(ref);

  Reference? get photoRef;
}

abstract class DataObjectWithPhoto extends DataObject
    implements PhotoObjectBase {
  DataObjectWithPhoto(JsonRef ref, String name) : super(ref, name);
  DataObjectWithPhoto.fromJson(Json data, JsonRef ref)
      : super.fromJson(data, ref);
  DataObjectWithPhoto.fromJsonDoc(JsonDoc doc) : super.fromJsonDoc(doc);

  @override
  final AsyncMemoizerCache<String> photoUrlCache = AsyncMemoizerCache<String>();
}

class SimplePhotoObject extends PhotoObjectBase {
  SimplePhotoObject(this.photoRef) : super(Icons.help, true);

  @override
  final Reference photoRef;
}
