import 'package:bloc_test/bloc_test.dart';
import 'package:news_today/themes/App_theme.dart';
import 'package:news_today/themes/cubit/theme_cubit.dart';
import 'package:test/test.dart';

void main() {
  group('Theme Cubit', () {
    late ThemeCubit themeCubit;

    setUp(() {
      themeCubit = ThemeCubit(appTheme: appLightTheme());
    });
    blocTest<ThemeCubit, ThemeState>(
        'change theme style from light to dark when toggleTheme called',
        build: () {
          return themeCubit;
        },
        act: (cubit) => cubit.toggleTheme(),
        expect: () => <ThemeState>[
              ThemeState(themeData: appDarkTheme()),
            ]);
  });
}
