import 'package:brandify/main.dart';
import 'package:flutter/material.dart';
import 'package:brandify/models/local/cache.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('ar'),
  ];

  String get language {
    switch (Localizations.localeOf(navigatorKey.currentState!.context).languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
      default:
        return 'English';
    }
  }

  static Locale getLocale(BuildContext context) {
    return Localizations.localeOf(context);
  }

  static void setLocale(BuildContext context, Locale locale) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.pushReplacement(
      MaterialPageRoute(
        builder: (_) => const MyApp(),
      ),
    );
  }

  static L10n? of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }
}