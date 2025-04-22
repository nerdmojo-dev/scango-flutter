// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A list of custom colors used in the application.
///
/// Will be ignored for test since all are static values and would not change.
abstract class ColorsValue {
  static const int primaryColorHex = 0xFF3F51B5; // Indigo
  static const int secondaryColorHex = 0xFF536DFE; // Indigo Accent

  static Color backgroundColor = const Color(0xFFFCFAFE);

  static const Color primaryColor = Color(primaryColorHex);
  static const Color secondaryColor = Color(secondaryColorHex);

  static Color themeOppositeColor() =>
      Get.isDarkMode ? Colors.white : backgroundColor;
}
