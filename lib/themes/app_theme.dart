import 'package:flutter/material.dart';
import 'package:news_today/themes/app_colors.dart';
import 'package:news_today/themes/app_text_styles.dart';

ThemeData appLightTheme() {
  final appColors = AppLightColors();
  return ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: appColors.primaryColor,
    // textTheme:
    //     Typography(platform: TargetPlatform.iOS).black.apply(fontSizeFactor: 1),
    appBarTheme: const AppBarTheme(
        color: Colors.transparent,
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        surfaceTintColor: Colors.transparent),
    tabBarTheme: const TabBarTheme(
      indicator: null,
      labelPadding: EdgeInsets.zero,
      indicatorColor: Colors.transparent,
      dividerColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      // indicatorSize: 0.0,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: appColors.primaryColor,
      elevation: 4.0,
    ),
  );
}

ThemeData appDarkTheme() {
  return ThemeData(
    brightness: Brightness.light,
  );
}

extension ColorsExtension on ThemeData {
  AppColors get appColors {
    return brightness == Brightness.light ? AppLightColors() : AppLightColors();
  }
}

extension TextStylesExtension on ThemeData {
  AppTextStyles get appTextStyles {
    return brightness == Brightness.light
        ? AppTextStyles(AppLightColors())
        : AppTextStyles(AppDarkColors());
  }
}
