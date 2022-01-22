import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../fakes/fake_cache_repo.dart';

void main() {
  group('ThemeNotifier tests ->', () {
    setUp(
      () async {
        GetIt.I.pushNewScope(scopeName: 'CacheTestsScope');
        GetIt.I.registerSingleton<CacheRepository>(
          FakeCacheRepo(),
          dispose: (r) => r.dispose(),
        );

        await GetIt.I<CacheRepository>().openBox('Settings');
      },
    );

    tearDown(
      () async {
        await GetIt.I.reset();
      },
    );

    test(
      'Default Theme: light',
      () async {
        await GetIt.I<CacheRepository>()
            .box('Settings')
            .put('GreatFeastTheme', false);

        final unit = ThemeNotifier.getDefault(darkTheme: false);
        final MaterialColor primary = Colors.blueGrey;
        const Color secondary = Colors.grey;

        expect(
          unit,
          predicate<ThemeData>(
            (t) =>
                t.colorScheme ==
                    ColorScheme.fromSwatch(
                      backgroundColor: Colors.grey[50],
                      primarySwatch: primary,
                      accentColor: secondary,
                    ) &&
                t.inputDecorationTheme ==
                    InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: primary),
                      ),
                    ) &&
                t.floatingActionButtonTheme ==
                    FloatingActionButtonThemeData(backgroundColor: primary) &&
                t.visualDensity == VisualDensity.adaptivePlatformDensity &&
                t.brightness == Brightness.light &&
                t.appBarTheme ==
                    AppBarTheme(
                      backgroundColor: primary,
                      foregroundColor:
                          Typography.material2018().black.headline6?.color,
                      systemOverlayStyle: SystemUiOverlayStyle.dark,
                    ) &&
                t.bottomAppBarTheme ==
                    const BottomAppBarTheme(
                      color: secondary,
                      shape: CircularNotchedRectangle(),
                    ),
          ),
        );
      },
    );

    test(
      'Default Theme: dark',
      () async {
        await GetIt.I<CacheRepository>()
            .box('Settings')
            .put('GreatFeastTheme', false);

        final unit = ThemeNotifier.getDefault(darkTheme: true);
        final MaterialColor primary = Colors.blueGrey;
        const Color secondary = Colors.grey;

        expect(
          unit,
          predicate<ThemeData>(
            (t) =>
                t.colorScheme ==
                    ColorScheme.fromSwatch(
                      backgroundColor: Colors.grey[850],
                      brightness: Brightness.dark,
                      primarySwatch: primary,
                      accentColor: secondary,
                    ) &&
                t.inputDecorationTheme ==
                    InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: primary),
                      ),
                    ) &&
                t.floatingActionButtonTheme ==
                    FloatingActionButtonThemeData(backgroundColor: primary) &&
                t.visualDensity == VisualDensity.adaptivePlatformDensity &&
                t.brightness == Brightness.dark &&
                t.appBarTheme ==
                    AppBarTheme(
                      backgroundColor: primary,
                      foregroundColor:
                          Typography.material2018().white.headline6?.color,
                      systemOverlayStyle: SystemUiOverlayStyle.light,
                    ) &&
                t.bottomAppBarTheme ==
                    const BottomAppBarTheme(
                      color: secondary,
                      shape: CircularNotchedRectangle(),
                    ),
          ),
        );
      },
    );
  });
}
