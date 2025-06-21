import 'dart:io';

import 'package:eyes_care/countdown_screen.dart';
import 'package:eyes_care/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> initLaunchStartup() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  launchAtStartup.setup(
    appName: packageInfo.appName,
    appPath: Platform.resolvedExecutable,
    packageName: packageInfo.packageName,
  );
}

Future<void> loadThemeMode() async {
  final mode = await PreferenceService.getThemeMode();
  if (mode == 'dark') {
    themeNotifier.value = ThemeMode.dark;
  } else if (mode == 'light') {
    themeNotifier.value = ThemeMode.light;
  } else if (mode == 'system') {
    themeNotifier.value = ThemeMode.system;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await loadThemeMode();
  runApp(const CareYourEyes());
}

final themeNotifier = ValueNotifier(ThemeMode.light);

class CareYourEyes extends StatelessWidget {
  const CareYourEyes({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      builder: (context, _, __) {
        const primaryColor = Color(0xFF5BE0E5);
        const secondaryColor = Color(0xFF32CD32);

        return MaterialApp(
          title: 'Eyes Care',
          debugShowCheckedModeBanner: false,
          themeMode: themeNotifier.value,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              secondary: secondaryColor,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(),
            cardTheme: CardThemeData(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              secondary: secondaryColor,
              brightness: Brightness.dark,
            ),
            textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
            cardTheme: CardThemeData(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
            ),
          ),
          home: const CountdownScreen(),
        );
      },
    );
  }
}
