import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_today/views/quick_reads_layout.dart';
import 'package:news_today/helpers/shared.dart';
import 'package:news_today/views/todays_news_layout.dart';
import 'package:news_today/views/top_news_layout.dart';
import 'package:news_today/themes/app_theme.dart';
import 'package:news_today/themes/cubit/theme_cubit.dart';

class HomeBody extends StatelessWidget {
  HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        // final newsState = BlocProvider.of<NewsCubit>(context).state;
        final themeState = BlocProvider.of<ThemeCubit>(context).state;
        // final scrollProvider = Provider.of<ScrollProvider>(context);

        return SafeArea(
          minimum: EdgeInsets.only(top: spPadding1),
          child: SingleChildScrollView(
            child: Column(
              // shrinkWrap: true,
              // controller: _homeScrollController,
              children: [
                Text(
                  'NEWS TODAY',
                  style: themeState.themeData.appTextStyles.headline,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spPadding2),
                QuickReadsLayout(
                    // sources: newsState.sources!,
                    appTextStyles: themeState.themeData.appTextStyles,
                    appColors: themeState.themeData.appTextStyles.appColors),
                SizedBox(height: spPadding1),
                const TopNewsLayout(),
                SizedBox(height: spPadding1),
                const TodaysNewsLayout(),
              ],
            ),
          ),
        );
      },
    );
  }
}
