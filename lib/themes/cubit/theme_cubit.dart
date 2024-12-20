import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:news_today/themes/App_theme.dart';
import 'package:news_today/themes/app_colors.dart';
import 'package:news_today/themes/app_text_styles.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit({required this.appTheme}) : super(ThemeState(themeData: appTheme));
  final ThemeData appTheme;

  void toggleTheme() {
    emit((state.themeData.brightness == Brightness.dark
        ? state.copyWith(themeData: appLightTheme())
        : state.copyWith(themeData: appDarkTheme())));
  }

  AppTextStyles get appTextStyles => state.themeData.appTextStyles;
  AppColors get appColors => state.themeData.appColors;
}
