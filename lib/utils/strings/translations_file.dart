import 'package:flutter/material.dart';
import 'package:get/get.dart';

// coverage:ignore-file
class TranslationsFile extends Translations {
  /// List of locales used in the application
  static const listOfLocales = <Locale>[Locale('en')];

  @override
  Map<String, Map<String, String>> get keys => {
    'en': {'appName': 'ScanGo'},
  };
}
