import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_today/themes/app_colors.dart';

class AppTextStyles {
  AppTextStyles(this.appColors);
  final AppColors appColors;

  double adjustFont(double base) {
    return ScreenUtil().screenWidth > 600 ? base * 0.8 : base;
  }

  TextStyle get headline => GoogleFonts.robotoSerif(
        // fontFamily: 'Georgia',
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w700,
        color: appColors.pinkColor,
        height: 1.2,
        fontSize: 18.0.sp,
      );

  TextStyle get titleLarge => GoogleFonts.wixMadeforDisplay(
        // fontFamily: 'Georgia',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        color: appColors.textTitleColor,
        height: 1.4,
        fontSize: 16.0.sp,
      );

  TextStyle get titleMediumItalic => TextStyle(
        fontFamily: 'Caros',
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
        color: appColors.textBodyColor,
        fontSize: 16.0.sp,
      );

  TextStyle get titleMedium => TextStyle(
        fontFamily: 'Caros',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        color: appColors.textBodyColor,
        fontSize: 16.0.sp,
      );

  TextStyle get bodyLarge => TextStyle(
        fontFamily: 'Caros',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        color: appColors.textBodyColor,
        fontSize: 14.0.sp,
      );

  TextStyle get bodyLarge2 => TextStyle(
        fontFamily: 'Caros',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        color: appColors.textBody2Color,
        fontSize: adjustFont(14.0.sp),
      );

  TextStyle get bodyMedium => TextStyle(
        fontFamily: 'Caros',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
        color: appColors.textBodyColor,
        fontSize: 14.0.sp,
      );

  TextStyle get bodyMedium2 => TextStyle(
        fontFamily: 'Caros',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
        color: appColors.textBody2Color,
        fontSize: 14.0.sp,
      );

  TextStyle get bodyBoldSmall => TextStyle(
        fontFamily: 'Caros',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        color: appColors.textBodySmallColor,
        fontSize: 12.0.sp,
      );

  TextStyle get bodySmall => TextStyle(
        fontFamily: 'Caros',
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
        color: appColors.textBodySmallColor,
        fontSize: 12.0.sp,
      );

  TextStyle get bodySmallItalic => TextStyle(
        fontFamily: 'Caros',
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.normal,
        color: appColors.textBodySmallColor,
        fontSize: 12.0.sp,
      );
}
