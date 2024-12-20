import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_api/news_api.dart';
import 'package:news_today/cubit/news_cubit.dart';
import 'package:news_today/helpers/shared.dart';
import 'package:news_today/shared_widgets.dart';
import 'package:news_today/themes/App_theme.dart';
import 'package:news_today/themes/app_colors.dart';
import 'package:news_today/themes/app_text_styles.dart';
import 'package:news_today/themes/cubit/theme_cubit.dart';
import 'package:news_today/views/content_screen.dart';

class TodaysNewsLayout extends StatefulWidget {
  const TodaysNewsLayout({super.key});

  @override
  State<TodaysNewsLayout> createState() => _TodaysNewsLayoutState();
}

class _TodaysNewsLayoutState extends State<TodaysNewsLayout>
    with SingleTickerProviderStateMixin {
  late NewsCubit _newsCubit;
  late List<ArticleCategory> _availableCategories;
  late TabController _tabController;
  late List<List<ArticleEntity>> _fetchedArticles;
  // late ScrollController _todaysNewsScroll;

  int currentTabIndex = 0;
  @override
  void initState() {
    super.initState();
    //retrieving available categories
    // _todaysNewsScroll = ScrollController();
    _newsCubit = BlocProvider.of<NewsCubit>(context);
    _availableCategories = _newsCubit.getAvailableCategories();
    _fetchedArticles = List.generate(_availableCategories.length, (_) => []);
    _tabController =
        TabController(length: _availableCategories.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          currentTabIndex = _tabController.index; // Update index
        });
      }
    });
  }

  @override
  void dispose() {
    // _todaysNewsScroll.dispose();
    _tabController.dispose();
    _newsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double fullWidth = MediaQuery.of(context).size.width;
    final double fullHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, themeState) {
      // final scrollProvider = Provider.of<ScrollProvider>(context);
      return SizedBox(
        height: fullHeight * 0.8,
        child: ListView(
          // controller: _todaysNewsScroll,
          physics: const NeverScrollableScrollPhysics(),
          // mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: spPadding1, vertical: padding3),
              child: Text('Today\'s News',
                  style: themeState.themeData.appTextStyles.titleLarge),
            ),
            SizedBox(
              height: 32.0.sp,
              child: TabBar(
                isScrollable: true,
                padding: EdgeInsets.zero,
                splashFactory: NoSplash.splashFactory,
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    return states.contains(WidgetState.focused)
                        ? null
                        : Colors.transparent;
                  },
                ),
                tabAlignment: TabAlignment.start,
                controller: _tabController,
                dividerColor: Colors.transparent,
                tabs: _availableCategories.asMap().entries.map((item) {
                  return Container(
                    margin: EdgeInsets.only(
                        left: item.key == 0 ? spPadding1 : 0.0,
                        right: spPadding1),
                    child: TabLayout(
                        tabTitle: item.value.value,
                        isPressed: currentTabIndex == item.key,
                        textStyles: themeState.themeData.appTextStyles,
                        appColors: themeState.themeData.appColors),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: spPadding1,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: spPadding1),
              height: fullHeight * 0.8,
              child: TabBarView(
                controller: _tabController,
                children: _availableCategories.asMap().entries.map((category) {
                  _fetchedArticles[category.key] =
                      _newsCubit.getCategoryArticles(category.value);
                  print(
                      '_fetchedArticles: ${_fetchedArticles[category.key].length}');
                  return _fetchedArticles[category.key].isEmpty
                      ? const SizedBox()
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: _fetchedArticles[category.key].length,
                          separatorBuilder: (context, index) => SizedBox(
                            height: spPadding2,
                          ),
                          itemBuilder: (context, index) {
                            if (index >=
                                _fetchedArticles[category.key].length) {
                              // Logging and handling out-of-range index
                              print('Index out of range: $index');
                              return const SizedBox();
                            }
                            return TabViewLayout(
                              article: _fetchedArticles[category.key][index],
                              articleCategory: category.value,
                              appTextStyles: themeState.themeData.appTextStyles,
                              fullWidth: fullWidth,
                              imagePlacementColor: themeState
                                  .themeData.appColors.accentColor
                                  .withOpacity(0.4),
                            );
                          },
                        );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class TabLayout extends StatelessWidget {
  const TabLayout(
      {super.key,
      required this.isPressed,
      required this.textStyles,
      required this.tabTitle,
      required this.appColors});
  final String tabTitle;
  final bool isPressed;
  final AppTextStyles textStyles;
  final AppColors appColors;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 120.0,
      // height: double.maxFinite,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius1),
        color: isPressed ? appColors.pinkColor : appColors.seconderColor,
      ),
      constraints: BoxConstraints(minWidth: 32.0, maxHeight: 24.0.sp),
      padding: const EdgeInsets.symmetric(horizontal: padding3),
      child: Text(
        tabTitle,
        textAlign: TextAlign.center,
        style: isPressed ? textStyles.bodyLarge2 : textStyles.bodyMedium,
      ),
    );
  }
}

class TabViewLayout extends StatelessWidget {
  const TabViewLayout(
      {super.key,
      required this.article,
      required this.articleCategory,
      required this.appTextStyles,
      required this.fullWidth,
      required this.imagePlacementColor});
  final ArticleEntity article;
  final ArticleCategory articleCategory;
  final AppTextStyles appTextStyles;
  final Color imagePlacementColor;

  final double fullWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('articleId: ${article.id}, articleCategory: $articleCategory');
        context.read<NewsCubit>().setSelectedArticle(
            articleId: article.id, articleCategory: articleCategory);
        // await context.read<NewsCubit>().fetchFullContent(articleId: article.id);
        if (context.read<NewsCubit>().state.contentLoadStatus.isLoading) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContentScreen(
                    articleId: article.id, articleCategory: articleCategory)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(appSnackBar(
              content: 'couldn\'t make it to the content',
              textStyle: appTextStyles.bodyMedium));
        }
      },
      child: SizedBox(
        height: 84.0.sp,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius1),
                child: CachedNetworkImage(
                  fit: BoxFit.fitHeight,
                  height: 84.0.sp,
                  imageUrl: article.urlToImage,
                  placeholder: (context, url) =>
                      appImagePlaceholder(imagePlacementColor),
                  errorWidget: (context, url, error) =>
                      appImagePlaceholder(imagePlacementColor),
                ),
              ),
            ),
            const SizedBox(width: padding3),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    article.title,
                    maxLines: 3,
                    style: appTextStyles.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    article.source.name!,
                    style: appTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
