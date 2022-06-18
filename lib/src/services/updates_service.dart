import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchdata_core/churchdata_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class UpdateService {
  Future<Version> getLatestVersion() async {
    final versionData = await GetIt.I<FirebaseDatabase>()
        .ref()
        .child('config')
        .child('updates')
        .child('latest_version')
        .once();
    return Version.parse(versionData.snapshot.value?.toString() ?? '0.0.0.0');
  }

  Future<Version> getLatestDeprecatedVersion() async {
    final versionData = await GetIt.I<FirebaseDatabase>()
        .ref()
        .child('config')
        .child('updates')
        .child('deprecated_from')
        .once();
    return Version.parse(versionData.snapshot.value?.toString() ?? '0.0.0.0');
  }

  Future<Uri> getDownloadLink() async {
    final linkData = await GetIt.I<FirebaseDatabase>()
        .ref()
        .child('config')
        .child('updates')
        .child('download_link')
        .once();
    return Uri.parse(linkData.snapshot.value.toString());
  }

  Future<Uri> getReleaseNotesLink() async {
    final linkData = await GetIt.I<FirebaseDatabase>()
        .ref()
        .child('config')
        .child('updates')
        .child('release_notes')
        .once();
    return Uri.parse(linkData.snapshot.value.toString());
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
