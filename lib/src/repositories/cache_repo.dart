// coverage:ignore-file
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

export 'package:hive/hive.dart' show HiveAesCipher;

class CacheRepository implements HiveInterface {
  CacheRepository() {
    Hive.initFlutter().then((_) => GetIt.I.signalReady(this));
  }

  @override
  Box<E> box<E>(String name) {
    return Hive.box<E>(name);
  }

  @override
  Future<bool> boxExists(String name, {String? path}) {
    return Hive.boxExists(name, path: path);
  }

  @override
  Future<void> close() {
    return Hive.close();
  }

  @override
  Future<void> deleteBoxFromDisk(String name, {String? path}) {
    return Hive.deleteBoxFromDisk(name, path: path);
  }

  @override
  Future<void> deleteFromDisk() {
    return Hive.deleteFromDisk();
  }

  @override
  List<int> generateSecureKey() {
    return Hive.generateSecureKey();
  }

  @override
  void ignoreTypeId<T>(int typeId) {
    return Hive.ignoreTypeId<T>(typeId);
  }

  @override
  void init(String path) {
    return Hive.init(path);
  }

  @override
  bool isAdapterRegistered(int typeId) {
    return Hive.isAdapterRegistered(typeId);
  }

  @override
  bool isBoxOpen(String name) {
    return Hive.isBoxOpen(name);
  }

  @override
  LazyBox<E> lazyBox<E>(String name) {
    return Hive.lazyBox<E>(name);
  }

  @override
  Future<Box<E>> openBox<E>(
    String name, {
    HiveCipher? encryptionCipher,
    KeyComparator keyComparator = defaultKeyComparator,
    CompactionStrategy compactionStrategy = defaultCompactionStrategy,
    bool crashRecovery = true,
    String? path,
    Uint8List? bytes,
    List<int>? encryptionKey,
  }) {
    return Hive.openBox<E>(
      name,
      bytes: bytes,
      compactionStrategy: compactionStrategy,
      crashRecovery: crashRecovery,
      encryptionCipher: encryptionCipher,
      keyComparator: keyComparator,
      path: path,
    );
  }

  @override
  Future<LazyBox<E>> openLazyBox<E>(
    String name, {
    HiveCipher? encryptionCipher,
    KeyComparator keyComparator = defaultKeyComparator,
    CompactionStrategy compactionStrategy = defaultCompactionStrategy,
    bool crashRecovery = true,
    String? path,
    List<int>? encryptionKey,
  }) {
    return Hive.openLazyBox<E>(
      name,
      compactionStrategy: compactionStrategy,
      crashRecovery: crashRecovery,
      encryptionCipher: encryptionCipher,
      keyComparator: keyComparator,
      path: path,
    );
  }

  @override
  void registerAdapter<T>(TypeAdapter<T> adapter,
      {bool internal = false, bool override = false}) {
    return Hive.registerAdapter<T>(adapter,
        internal: internal, override: override);
  }

  Future<void> dispose() {
    return close();
  }
}

const _deletedRatio = 0.15;
const _deletedThreshold = 60;

/// Default compaction strategy compacts if 15% of total values and at least 60
/// values have been deleted
bool defaultCompactionStrategy(int entries, int deletedEntries) {
  return deletedEntries > _deletedThreshold &&
      deletedEntries / entries > _deletedRatio;
}

/// Efficient default implementation to compare keys
int defaultKeyComparator(dynamic k1, dynamic k2) {
  if (k1 is int) {
    if (k2 is int) {
      if (k1 > k2) {
        return 1;
      } else if (k1 < k2) {
        return -1;
      } else {
        return 0;
      }
    } else {
      return -1;
    }
  } else if (k2 is String) {
    return (k1 as String).compareTo(k2);
  } else {
    return 1;
  }
}
