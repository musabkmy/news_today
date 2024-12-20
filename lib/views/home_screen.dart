// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_today/cubit/news_cubit.dart';
import 'package:news_today/views/home_body.dart';
import 'package:news_today/themes/cubit/theme_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    //initiate the app
    context.read<NewsCubit>().initiate();
    //load sources placement image
    // precacheImage(const AssetImage(sourceFavIconPlacement), context);
  }

  void printScreenInformation(BuildContext context) {
    print('Device Size:${Size(1.sw, 1.sh)}');
    print('Device pixel density:${ScreenUtil().pixelRatio}');
    print('Bottom safe zone distance dp:${ScreenUtil().bottomBarHeight}dp');
    print('Status bar height dp:${ScreenUtil().statusBarHeight}dp');
    print('The ratio of actual width to UI design:${ScreenUtil().scaleWidth}');
    print(
        'The ratio of actual height to UI design:${ScreenUtil().scaleHeight}');
    print('System font scaling:${ScreenUtil().textScaleFactor}');
    print('0.5 times the screen width:${0.5.sw}dp');
    print('0.5 times the screen height:${0.5.sh}dp');
    print('Screen orientation:${ScreenUtil().orientation}');
  }

  @override
  Widget build(BuildContext context) {
    printScreenInformation(context);
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: false,
      //   title: Text('NEWS TODAY', style: themeCubit.appTextStyles.headline),
      // ),
      body: Builder(builder: (context) {
        final ThemeCubit themeCubit = context.watch<ThemeCubit>();
        final NewsStatus newsStatus = context.watch<NewsCubit>().state.status;

        if (newsStatus == NewsStatus.success) {
          print('in success');
          return HomeBody();
        } else if (newsStatus == NewsStatus.loading) {
          return const LinearProgressIndicator();
        }
        return Text('something went wrong',
            style: themeCubit.appTextStyles.bodyLarge);
      }),
    );
  }
}
