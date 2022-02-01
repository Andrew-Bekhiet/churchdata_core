import 'package:churchdata_core/churchdata_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class DatabaseRepository {
  DatabaseRepository();

  // coverage:ignore-start
  Query<Json> collectionGroup(String path) =>
      GetIt.I<FirebaseFirestore>().collectionGroup(path);

  JsonCollectionRef collection(String path) =>
      GetIt.I<FirebaseFirestore>().collection(path);

  JsonRef doc(String path) => GetIt.I<FirebaseFirestore>().doc(path);

  WriteBatch batch() => GetIt.I<FirebaseFirestore>().batch();

  Future<void> disableNetwork() =>
      GetIt.I<FirebaseFirestore>().disableNetwork();

  Future<void> enableNetwork() => GetIt.I<FirebaseFirestore>().enableNetwork();

  Future<T> Function<T>(TransactionHandler<T>, {Duration timeout})
      get runTransaction => GetIt.I<FirebaseFirestore>().runTransaction;
  // coverage:ignore-end

  Future<DataObject?> getObjectFromLink(Uri deepLink) async {
    if (deepLink.pathSegments[0] == 'PersonInfo') {
      if (deepLink.queryParameters['Id'] == '')
        throw Exception('Id has an empty value which is not allowed');

      return getPerson(
        deepLink.queryParameters['Id']!,
      );
    } else if (deepLink.pathSegments[0] == 'UserInfo') {
      if (deepLink.queryParameters['UID'] == '')
        throw Exception('UID has an empty value which is not allowed');

      return getUserData(
        deepLink.queryParameters['UID']!,
      );
    } else if (deepLink.pathSegments[0] == 'viewQuery') {
      return QueryInfo.fromJson(deepLink.queryParameters);
    }

    return null;
  }

  Future<PersonBase?> getUserData(String uid) async {
    final doc = (await collection('Persons').where('UID', isEqualTo: uid).get())
        .docs
        .singleOrNull;

    if (doc == null) return null;

    return PersonBase.fromDoc(
      doc,
    );
  }

  Future<PersonBase?> getPerson(String id) async {
    final doc = await collection('Persons').doc(id).get();

    if (!doc.exists) return null;

    return PersonBase.fromDoc(
      doc,
    );
  }

  Stream<List<PersonBase>> getPersonsStream({
    String orderBy = 'Name',
    bool descending = false,
    QueryCompleter queryCompleter = kDefaultQueryCompleter,
  }) {
    return queryCompleter(collection('Persons'), orderBy, descending)
        .snapshots()
        .map((p) => p.docs.map(PersonBase.fromDoc).toList());
  }

  Future<void> recoverDocument(
    BuildContext context,
    JsonRef documentRef, {
    bool nested = true,
    bool keepBackup = true,
  }) async {
    final dialogResult = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('استرجاع'),
          ),
        ],
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: nested,
                      onChanged: (v) => setState(() => nested = v!),
                    ),
                    const Text(
                      'استرجع ايضا العناصر بداخل هذا العنصر',
                      textScaleFactor: 0.9,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: keepBackup,
                      onChanged: (v) => setState(() => keepBackup = v!),
                    ),
                    const Text('ابقاء البيانات المحذوفة'),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );

    if (dialogResult == true) {
      try {
        await GetIt.I<FunctionsService>().recoverDocument(
          documentRef.path,
          keepBackup: keepBackup,
          nested: nested,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم الاسترجاع بنجاح'),
          ),
        );
      } on Exception catch (err, stack) {
        await GetIt.I<LoggingService>().reportError(
          err,
          stackTrace: stack,
        );
      }
    }
  }
}

Query<Json> kDefaultQueryCompleter(Query<Json> q, String o, bool descending) =>
    q.orderBy(o, descending: descending);
