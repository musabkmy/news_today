import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_api/news_api.dart';
import 'package:news_today/cubit/news_cubit.dart';
import 'package:news_today/helpers/shared.dart';
import 'package:news_today/shared_widgets.dart';
import 'package:news_today/themes/cubit/theme_cubit.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen(
      {super.key,
      required this.articleId,
      this.articleCategory = ArticleCategory.unknown});
  final String articleId;
  final ArticleCategory articleCategory;

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializer();
    });
  }

  void _initializer() async {
    if (!mounted) {
      print('mounted');
      return;
    }
    await context.read<NewsCubit>().fetchFullContent(
        articleId: widget.articleId, articleCategory: widget.articleCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          // final ThemeCubit themeCubit = context.watch<ThemeCubit>();
          // final ContentLoadStatus contentLoadStatus =
          //     context.watch<NewsCubit>().state.contentLoadStatus;
          return const SafeArea(
            child: Stack(
              children: [
                TopScreenWidget(),
                ContentLayout(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ContentLayout extends StatelessWidget {
  const ContentLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: spPadding1)
          .copyWith(top: spPadding4),
      child: Builder(
        builder: (context) {
          final ThemeCubit appTheme = context.watch<ThemeCubit>();
          // final ArticleEntity? article =
          //     context.watch<NewsCubit>().state.selectedArticle;
          //     context.watch<NewsCubit>().state.contentLoadStatus;
          return BlocSelector<NewsCubit, NewsState,
                  (ArticleEntity?, ContentLoadStatus)>(
              selector: (state) =>
                  (state.selectedArticle, state.contentLoadStatus),
              builder: (context, state) {
                final ArticleEntity? article = state.$1;
                final ContentLoadStatus contentLoadStatus = state.$2;
                print('article: ${article!.id}');
                print('contentLoadStatus: $contentLoadStatus');
                return ListView(children: [
                  Text(
                    article.title.substring(
                        0,
                        article.title.contains('-')
                            ? article.title.indexOf('-') - 1
                            : article.title.length),
                    style: appTheme.appTextStyles.titleLarge,
                  ),
                  SizedBox(height: spPadding1),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(radius2),
                    child: Hero(
                      tag: 'article-image${article.id}',
                      child: CachedNetworkImage(
                        imageUrl: article.urlToImage,
                        placeholder: (context, url) => appImagePlaceholder(
                            appTheme.appColors.primaryColor),
                        errorWidget: (context, url, error) =>
                            appImagePlaceholder(
                                appTheme.appColors.primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(height: spPadding1),
                  Text(
                      article.source.name! +
                          (article.author == '' ? '' : ' • ${article.author}'),
                      style: appTheme.appTextStyles.bodyBoldSmall),
                  Divider(
                    height: spPadding3,
                    thickness: 2.0,
                    color: appTheme.appColors.seconderColor,
                  ),
                  LoadedLayout(),
                ]);
              });
        },
      ),
    );
  }
}

class TopScreenWidget extends StatelessWidget {
  const TopScreenWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: spPadding4,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: spPadding05),
      // padding: const EdgeInsets.only(bottom: padding4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.watch<ThemeCubit>().appColors.accentColor,
              size: spPadding3,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          //TODO: switch light/dark mood
        ],
      ),
    );
  }
}

class LoadedLayout extends StatelessWidget {
  LoadedLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NewsCubit, NewsState,
        (ContentLoadStatus, ArticleEntity?)>(
      selector: (state) => (state.contentLoadStatus, state.selectedArticle),
      builder: (context, records) {
        final ThemeCubit appTheme = context.watch<ThemeCubit>();
        final ContentLoadStatus status = records.$1;
        final ArticleEntity article = records.$2!;
        // Check the Content availability
        return switch (status) {
          ContentLoadStatus.initial => const SizedBox(),
          ContentLoadStatus.loading => const Center(child: Text('loading')),
          // const Center(child: CircularProgressIndicator()),
          // ContentLoadStatus.success => const Center(child: Text('success')),
          ContentLoadStatus.success => Text(
              article.fullContentStatus.isFetched
                  ? article.fullContent!
                  : article.content,
              style: appTheme.appTextStyles.bodyMedium,
              textAlign: TextAlign.justify,
            ),
          ContentLoadStatus.failure => Center(
              child: Text(
                context.watch<NewsCubit>().state.contentLoadErrorMessage,
                style: appTheme.appTextStyles.bodyMedium,
              ),
            ),
        };
      },
    );
  }
}
