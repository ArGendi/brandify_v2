import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:brandify/models/local/cache.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(_getInitialLocale());

  static Locale _getInitialLocale() {
    String? savedLanguage = Cache.getLanguage();
    if (savedLanguage != null) {
      return Locale(savedLanguage);
    }

    String deviceLanguage = Platform.localeName.split('_')[0];
    if (deviceLanguage == 'ar' || deviceLanguage == 'en') {
      return Locale(deviceLanguage);
    }
    
    return const Locale('en');
  }

  void changeLanguage(String languageCode) async {
    await Cache.setLanguage(languageCode);
    emit(Locale(languageCode));
  }
}