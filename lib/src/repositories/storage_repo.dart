import 'package:churchdata_core/churchdata_core.dart';
import 'package:firebase_storage/firebase_storage.dart' hide Reference;
import 'package:get_it/get_it.dart';

class StorageRepository {
  StorageRepository();

  Reference ref([String? path]) =>
      StorageReference.fromFirebaseRef(GetIt.I<FirebaseStorage>().ref(path));
}
