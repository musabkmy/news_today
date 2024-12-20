import 'package:flutter/material.dart';

abstract class AppColors {
  Color get primaryColor;
  Color get seconderColor;
  Color get accentColor;
  Color get pinkColor;
  Color get textTitleColor;
  Color get textBodyColor;
  Color get textBody2Color;
  Color get textBodySmallColor;
}

class AppLightColors extends AppColors {
  @override
  Color get primaryColor => const Color(0xFFFAFAFA);

  @override
  Color get seconderColor => const Color(0xFFF2F2F2);

  @override
  Color get accentColor => const Color(0xFF1E1E2C);

  @override
  Color get pinkColor => const Color(0xFF8B0000);

  @override
  Color get textTitleColor => const Color(0xFF1E1E2C);

  @override
  Color get textBodyColor => const Color(0xFF1E1E2C);

  @override
  Color get textBody2Color => const Color(0xFFFAFAFA);

  @override
  Color get textBodySmallColor => const Color(0xFFBCBCBC);
}

class AppDarkColors extends AppColors {
  @override
  Color get primaryColor => const Color(0xFFFAFAFA);

  @override
  Color get seconderColor => const Color(0xFFF2F2F2);

  @override
  Color get accentColor => const Color(0xFF1E1E2C);

  @override
  Color get pinkColor => const Color(0xFFD32F2F);

  @override
  Color get textTitleColor => const Color(0xFFFAFAFA);

  @override
  Color get textBodyColor => const Color(0xFFFAFAFA);

  @override
  Color get textBody2Color => const Color(0xFFB0B0B0);

  @override
  Color get textBodySmallColor => const Color(0xFF8C8C8C);
}
