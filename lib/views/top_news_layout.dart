import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_api/news_api.dart';
import 'package:news_today/views/content_screen.dart';
import 'package:news_today/cubit/news_cubit.dart';
import 'package:news_today/helpers/shared.dart';
import 'package:news_today/shared_widgets.dart';
import 'package:news_today/themes/App_theme.dart';
import 'package:news_today/themes/cubit/theme_cubit.dart';

class TopNewsLayout extends StatelessWidget {
  const TopNewsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(builder: (context, themeState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: spPadding1, vertical: padding3),
            child: Text('Top News',
                style: themeState.themeData.appTextStyles.titleLarge),
          ),
          BlocSelector<NewsCubit, NewsState, List<ArticleEntity>?>(
              selector: (state) => state.topNews,
              builder: (context, newsState) {
                return Container(
                  height: 160.0.h,
                  constraints: const BoxConstraints(maxHeight: 340.0),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: newsState!.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(width: spPadding1),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                            left: index == 0 ? spPadding1 : 0.0,
                            right: index == newsState.length - 1
                                ? spPadding1
                                : 0.0),
                        child: TopNewsArticle(
                          article: newsState[index],
                          articleTitleStyle:
                              themeState.themeData.appTextStyles.bodyLarge2,
                          placementColor:
                              themeState.themeData.appColors.accentColor,
                        ),
                      );
                    },
                  ),
                );
              }),
        ],
      );
    });
  }
}

class TopNewsArticle extends StatelessWidget {
  const TopNewsArticle(
      {super.key,
      required this.article,
      required this.articleTitleStyle,
      required this.placementColor});
  final ArticleEntity article;
  final TextStyle articleTitleStyle;
  final Color placementColor;

  @override
  Widget build(BuildContext context) {
    // print('image url: ${article.urlToImage}');
    return GestureDetector(
      onTap: () {
        context.read<NewsCubit>().setSelectedArticle(articleId: article.id);
        // await context.read<NewsCubit>().fetchFullContent(articleId: article.id);
        if (context.read<NewsCubit>().state.contentLoadStatus.isLoading) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContentScreen(articleId: article.id)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(appSnackBar(
              content: 'couldn\'t make it to the content',
              textStyle: articleTitleStyle));
        }
      },
      child: Container(
        width: 0.6.sw,
        constraints: const BoxConstraints(minWidth: 340.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(radius1),
              child: Hero(
                tag: 'article-image${article.id}',
                child: CachedNetworkImage(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                  imageUrl: article.urlToImage,
                  color: placementColor.withOpacity(0.5), // Color tint
                  colorBlendMode: BlendMode.multiply,
                  placeholder: (context, url) =>
                      appImagePlaceholder(placementColor),
                  errorWidget: (context, url, error) =>
                      appImagePlaceholder(placementColor),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(padding3),
              child: Text(
                article.title,
                style: articleTitleStyle.copyWith(
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: placementColor.withOpacity(0.4),
                      offset: const Offset(2.0, 2.0),
                    ),
                  ],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
