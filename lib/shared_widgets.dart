import 'package:flutter/material.dart';
import 'package:news_today/helpers/shared.dart';

Widget appImagePlaceholder(Color color, {bool isCircle = false}) {
  return Container(
      decoration: isCircle
          ? BoxDecoration(shape: BoxShape.circle, color: color)
          : BoxDecoration(
              color: color.withRed(102).withGreen(102).withBlue(102),
              borderRadius: BorderRadius.circular(radius1)),
      height: double.maxFinite,
      width: double.maxFinite);
}

SnackBar appSnackBar({required String content, required TextStyle textStyle}) {
  return SnackBar(
      content: Text(
    content,
    style: textStyle,
  ));
}
