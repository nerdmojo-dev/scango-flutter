// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A list of custom color used in the application.
///
/// Will be ignored for test since all are static values and would not change.
abstract class ColorsValue {
  static const int primaryColorHex = 0xff4313A1;
  static const int secondaryColorHex = 0xffDAC5FF;
  static Color backgroundColor = Color(0xffFCFAFE);

  static const Color primaryColor = Color(primaryColorHex);

  static const Color secondaryColor = Color(secondaryColorHex);

  static Color themeOppositeColor() =>
      Get.isDarkMode ? Colors.white : backgroundColor;
}
