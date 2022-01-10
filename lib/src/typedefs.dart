import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_storage/firebase_storage.dart' as storage;

typedef Json = Map<String, dynamic>;

typedef JsonDoc = firestore.DocumentSnapshot<Json>;
typedef JsonQueryDoc = firestore.QueryDocumentSnapshot<Json>;
typedef JsonRef = firestore.DocumentReference<Json>;
typedef JsonQuery = firestore.QuerySnapshot<Json>;
typedef QueryOfJson = firestore.Query<Json>;
typedef JsonCollectionRef = firestore.CollectionReference<Json>;
typedef Timestamp = firestore.Timestamp;
typedef GeoPoint = firestore.GeoPoint;

typedef Reference = storage.Reference;
typedef QueryCompleter = firestore.Query<Json> Function(
    firestore.Query<Json>, String, bool);
