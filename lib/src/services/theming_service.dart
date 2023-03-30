import 'package:churchdata_core/churchdata_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class ThemingService {
  static const MaterialColor black = MaterialColor(0xFF000000, <int, Color>{
    50: Color(0xFFE0E0E0),
    100: Color(0xFFB3B3B3),
    200: Color(0xFF808080),
    300: Color(0xFF4D4D4D),
    400: Color(0xFF262626),
    500: Color(0xFF000000),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  });

  static const MaterialColor blackAccent =
      MaterialColor(0xFF8C8C8C, <int, Color>{
    100: Color(0xFFA6A6A6),
    200: Color(0xFF8C8C8C),
    400: Color(0xFF737373),
    700: Color(0xFF666666),
  });

  static ThemeData getDefault({
    bool? darkTheme,
    MaterialColor? primaryOverride,
    Color? secondaryOverride,
    bool? greatFeastThemeOverride,
  }) {
    bool isDark = darkTheme ??
        GetIt.I<CacheRepository>().box('Settings').get('DarkTheme') ??
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark;

    final bool greatFeastTheme = GetIt.I<CacheRepository>()
        .box('Settings')
        .get('GreatFeastTheme', defaultValue: greatFeastThemeOverride ?? true);

    MaterialColor primary = primaryOverride ?? Colors.blueGrey;
    Color secondary = secondaryOverride ?? Colors.grey;

    final riseDay = getRiseDay();
    if (greatFeastTheme &&
        DateTime.now()
            .isAfter(riseDay.subtract(const Duration(days: 7, seconds: 20))) &&
        DateTime.now().isBefore(riseDay.subtract(const Duration(days: 1)))) {
      primary = black;
      secondary = blackAccent;
      isDark = true;
    } else if (greatFeastTheme &&
        DateTime.now()
            .isBefore(riseDay.add(const Duration(days: 50, seconds: 20))) &&
        DateTime.now().isAfter(riseDay.subtract(const Duration(days: 1)))) {
      isDark = false;
    }

    return ThemeData.from(
      colorScheme: ColorScheme.fromSwatch(
        backgroundColor: isDark ? Colors.grey[850]! : Colors.grey[50]!,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primarySwatch: primary,
        accentColor: secondary,
      ),
    ).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: primary),
        ),
      ),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: primary),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: isDark ? Brightness.dark : Brightness.light,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: (isDark
                ? Typography.material2018().white
                : Typography.material2018().black)
            .titleLarge
            ?.color,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: secondary,
        shape: const CircularNotchedRectangle(),
      ),
    );
  }

  factory ThemingService() => ThemingService.withInitialThemeata(getDefault());

  ThemingService.withInitialThemeata(ThemeData initialTheme)
      : _themeData = BehaviorSubject.seeded(initialTheme);

  final BehaviorSubject<ThemeData> _themeData;

  Stream<ThemeData> get stream => _themeData.share();

  ThemeData get theme => _themeData.value;
  set theme(ThemeData themeData) {
    _themeData.add(themeData);
  }

  void switchTheme(bool darkTheme) {
    theme = getDefault(darkTheme: darkTheme);
  }

  Future<void> dispose() async {
    await _themeData.close();
  }
}
