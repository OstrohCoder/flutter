import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_store_localization_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/locale_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'My Store',
      locale: localeProvider.locale,

      // ← ЛОКАЛІЗАЦІЯ
      localizationsDelegates: const [
        AppLocalizations.delegate, // ← Наші переклади
        GlobalMaterialLocalizations.delegate, // ← Material widgets
        GlobalWidgetsLocalizations.delegate, // ← Text direction
        GlobalCupertinoLocalizations.delegate, // ← iOS widgets
      ],

      supportedLocales: const [
        Locale('en'),
        Locale('uk'),
        Locale('pl'),
        Locale('fr'),
        Locale('ar'),
      ],

      // Якщо мова пристрою не підтримується - використати англійську
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return supportedLocales.first;

        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first; // default to English
      },

      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: HomeScreen(key: ValueKey(localeProvider.locale)),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
