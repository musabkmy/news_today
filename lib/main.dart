import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_today/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Center(
      child: Text('Something went wrong! ${details.exception}'),
    );
  };

  // final newsApi = NewsOpenApi();
  bootstrap();
}
