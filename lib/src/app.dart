import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_api/news_api.dart';
import 'package:news_today/cubit/news_cubit.dart';
import 'package:news_today/providers/scroll_state.dart';
import 'package:news_today/views/home_screen.dart';
import 'package:news_today/themes/App_theme.dart';
import 'package:news_today/themes/cubit/theme_cubit.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  // final NewsRepository userRepo;
  const App({
    super.key,
    required this.newsRepository,
    // required this.settingsController,
  });
  final NewsApi newsRepository;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    );

    //Set the fit size (fill in the screen size of the device in the design)
    //If the design is based on the size of the 360*690(dp)
    // ScreenUtil.init(context, designSize: const Size(360, 690));

    return RepositoryProvider.value(
      value: newsRepository,
      child: MultiBlocProvider(
          providers: [
            BlocProvider<ThemeCubit>(
              create: (context) => ThemeCubit(
                appTheme: appLightTheme(),
              ),
            ),
            BlocProvider<NewsCubit>(
              create: (context) => NewsCubit(newsRepository),
            ),
          ],
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return ChangeNotifierProvider<ScrollProvider>(
                create: (BuildContext context) => ScrollProvider(),
                child: ScreenUtilInit(
                  designSize: const Size(360, 690),
                  ensureScreenSize: true,
                  enableScaleWH: () => true,
                  // minTextAdapt: true,
                  enableScaleText: () => false,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: themeState.themeData,
                    themeMode: ThemeMode.dark,
                    home: const HomeScreen(),
                  ),
                ),
              );
            },
          )),
    );
  }
}
