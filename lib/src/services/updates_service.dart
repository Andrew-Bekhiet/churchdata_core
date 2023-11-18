import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchdata_core/churchdata_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class UpdatesService {
  bool _disposed = false;

  UpdatesService() {
    init();
  }

  Future<void> init() async {
    await GetIt.I<CacheRepository>().openBox('Updates');

    if (!_disposed && !GetIt.I.isReadySync(instance: this))
      GetIt.I.signalReady(this);
  }

  Future<void> dispose() async {
    if (_disposed) throw Exception('Already disposed');

    _disposed = true;

    await GetIt.I<CacheRepository>().box('Updates').close();
  }

  @visibleForTesting
  String? getCachedValue(String key) {
    return GetIt.I<CacheRepository>().box('Updates').get(key);
  }

  @visibleForTesting
  Future setCachedValue(String key, String? value) async {
    return GetIt.I<CacheRepository>().box('Updates').put(key, value);
  }

  @visibleForTesting
  Future<DatabaseEvent> Function(DatabaseEvent) saveCachedValueFromDB(
      String key) {
    return (DatabaseEvent value) async {
      if (getCachedValue(key) != value.snapshot.value)
        await setCachedValue(key, value.snapshot.value?.toString());

      return value;
    };
  }

  Future<Version> getLatestVersion() async {
    try {
      final versionData = await GetIt.I<FirebaseDatabase>()
          .ref()
          .child('config')
          .child('updates')
          .child('latest_version')
          .once()
          .timeout(const Duration(seconds: 5))
          .then(saveCachedValueFromDB('latest_version'));
      return Version.parse(versionData.snapshot.value?.toString() ?? '0.0.0.0');
    } on Exception {
      return Version.parse(
        getCachedValue('latest_version') ?? '0.0.0.0',
      );
    }
  }

  Future<Version> getLatestDeprecatedVersion() async {
    try {
      final versionData = await GetIt.I<FirebaseDatabase>()
          .ref()
          .child('config')
          .child('updates')
          .child('deprecated_from')
          .once()
          .timeout(const Duration(seconds: 5))
          .then(saveCachedValueFromDB('deprecated_from'));
      return Version.parse(versionData.snapshot.value?.toString() ?? '0.0.0.0');
    } on Exception {
      return Version.parse(
        getCachedValue('deprecated_from') ?? '0.0.0.0',
      );
    }
  }

  Future<Uri> getDownloadLink() async {
    try {
      final linkData = await GetIt.I<FirebaseDatabase>()
          .ref()
          .child('config')
          .child('updates')
          .child('download_link')
          .once()
          .timeout(const Duration(seconds: 5))
          .then(saveCachedValueFromDB('download_link'));
      return Uri.parse(linkData.snapshot.value.toString());
    } on Exception {
      return Uri.parse(
        getCachedValue('download_link') ?? '0.0.0.0',
      );
    }
  }

  Future<Uri> getReleaseNotesLink() async {
    try {
      final linkData = await GetIt.I<FirebaseDatabase>()
          .ref()
          .child('config')
          .child('updates')
          .child('release_notes')
          .once()
          .timeout(const Duration(seconds: 5))
          .then(saveCachedValueFromDB('release_notes'));
      return Uri.parse(linkData.snapshot.value.toString());
    } on Exception {
      return Uri.parse(
        getCachedValue('release_notes') ?? '0.0.0.0',
      );
    }
  }

  Future<Version> getCurrentVersion() async {
    return Version.parse((await PackageInfo.fromPlatform()).version);
  }

  Future<bool> isUpToDate() async {
    return await getCurrentVersion() >= await getLatestVersion();
  }

  Future<bool> currentIsDeprecated() async {
    return await getCurrentVersion() <= await getLatestDeprecatedVersion();
  }

  Future<void> showUpdateDialog(
    BuildContext context, {
    ImageProvider? image,
    Widget? content,
  }) async {
    assert(image == null || content == null);

    final canCancel = !await currentIsDeprecated();

    await showDialog(
      barrierDismissible: canCancel,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('أخبار سارة! يوجد تحديث جديد🎉'),
          scrollable: true,
          content: content ??
              Image(
                image: image ??
                    const CachedNetworkImageProvider(
                      'https://github.com/Andrew-Bekhiet/churchdata_core'
                      '/blob/master/Logo.png?raw=true',
                    ),
              ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () async {
                if (canCancel) Navigator.of(context).pop();

                unawaited(GetIt.I<LauncherService>()
                    .launchUrl(await getDownloadLink()));
              },
              style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              child: const Text('تحديث'),
            ),
            TextButton(
              onPressed: () async {
                if (canCancel) Navigator.of(context).pop();

                unawaited(GetIt.I<LauncherService>()
                    .launchUrl(await getReleaseNotesLink()));
              },
              child: const Text('الاطلاع على التغييرات'),
            ),
          ],
        );
      },
    );
  }
}
