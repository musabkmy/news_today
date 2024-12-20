// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_api/news_api.dart';
import 'package:news_today/cubit/helpers/error_messages.dart';
import 'package:news_today/extenstions/str_extenstions.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit(this._newsApi) : super(NewsState());
  final NewsApi _newsApi;
  //  = NewsOpenApi();

  @override
  Future<void> close() {
    // Log a message when close is called
    print('NewsCubit is being closed');
    return super.close();
  }

  Future<void> initiate() async {
    emit(state.copyWith(status: NewsStatus.loading));
    List<SourceEntity> sources = [];
    List<ArticleEntity> topNews = [];
    Map<ArticleCategory, List<ArticleEntity>> todaysNews = {};
    try {
      sources = (await _newsApi.fetchSources());
      // if (sources.isEmpty) throw SourcesNotFoundException();
      // print('Sources: $sources');

      topNews = (await _newsApi.fetchTopNews());
      // if (topNews.isEmpty) throw TopArticlesNotFoundException();
      print('Top News: $topNews');

      todaysNews = (await _newsApi.fetchTodaysNews(sources));
      // if (todaysNews.isEmpty) throw TodaysArticlesNotFoundException();
      print('Today\'s News: ${todaysNews.values.length}');

      emit(state.copyWith(
          status: NewsStatus.success,
          sources: sources,
          topNews: topNews,
          todaysNews: todaysNews,
          errorMessage: ''));
    } on Exception catch (e) {
      emit(state.copyWith(
          status: NewsStatus.failure, errorMessage: e.toString()));
    } catch (e) {
      emit(state.copyWith(
          status: NewsStatus.failure, errorMessage: e.toString()));
    }
  }

  List<ArticleCategory> getAvailableCategories() {
    print('at available categories: ${state.todaysNews} with ${state.status}');
    if (state.status == NewsStatus.success &&
        state.todaysNews != null &&
        state.todaysNews!.isNotEmpty) {
      //avoiding redundant values
      Set<ArticleCategory> categories = {ArticleCategory.all};
      for (ArticleCategory key in ArticleCategory.values) {
        if (state.todaysNews!.containsKey(key)) {
          categories.add(key);
        }
      }

      for (var v in categories) {
        print('Available Category: ${v.name}');
      }
      return categories.toList();
    }
    print('only all');
    return [ArticleCategory.all];
  }

  List<ArticleEntity> getCategoryArticles(ArticleCategory category) {
    if (state.status == NewsStatus.success &&
        state.todaysNews != null &&
        state.todaysNews!.isNotEmpty) {
      if (category == ArticleCategory.all) {
        for (var v in state.todaysNews!.values) {
          print('all Categories: ${v.length}');
        }
        return state.todaysNews!.values.expand((articles) => articles).toList();
      } else if (state.todaysNews!.containsKey(category)) {
        print('add Category: $category');
        return state.todaysNews![category]!.toList();
      } else {
        print('no added Category: $category');
      }
    }
    print('return []');
    return [];
  }

  //set selected article and article loading to true if it found, otherwise do noting
  void setSelectedArticle(
      {required String? articleId,
      ArticleCategory articleCategory = ArticleCategory.unknown}) {
    int index;
    //check if in top new
    if (articleCategory.isUnknown) {
      index = state.topNews!.indexWhere((item) => item.id == articleId);
      if (index != -1) {
        emit(state.copyWith(
          selectedArticle: state.topNews![index],
          contentLoadStatus: ContentLoadStatus.loading,
        ));
      }
    } else {
      index = state.todaysNews![articleCategory]!
          .indexWhere((item) => item.id == articleId);
      if (index != -1) {
        emit(state.copyWith(
          selectedArticle: state.todaysNews![articleCategory]![index],
          contentLoadStatus: ContentLoadStatus.loading,
        ));
      }
    }
  }

  //fetch article content -- in top news or todays news
  Future<void> fetchFullContent(
      {required String articleId,
      ArticleCategory articleCategory = ArticleCategory.unknown}) async {
    print('inError: ${state.status}');

    if (state.status.isSuccess) {
      // emit(state.copyWith(contentLoadStatus: ContentLoadStatus.loading));
      try {
        int articleIndex = -1;
        String? contentURL;
        String? contentInfo;
        late String returnedFullContent = '';

        //should be in the top news articles
        if (articleCategory == ArticleCategory.unknown) {
          List<ArticleEntity> topArticles = state.topNews!;
          articleIndex =
              topArticles.indexWhere((article) => article.id == articleId);
          if (articleIndex == -1) {
            emit(state.copyWith(
                contentLoadStatus: ContentLoadStatus.failure,
                contentLoadErrorMessage: CubitErrors.articleNotFound));
            return; // Early return to stop further processing
          }
          //if already fetched
          else if (topArticles[articleIndex].fullContentStatus.isFetched) {
            emit(state.copyWith(
                contentLoadStatus: ContentLoadStatus.success,
                selectedArticle: topArticles[articleIndex]));
            return;
          }

          contentURL = topArticles[articleIndex].url;
          contentInfo = topArticles[articleIndex].content;
          print('in top - contentURL: $contentURL - contentInfo $contentInfo');

          //fetched the content
          returnedFullContent = await _newsApi.fetchFullContent(
              contentURL: contentURL, contentInfo: contentInfo);
          print('returnedFullContent is: $returnedFullContent');

          // create an updated list with the updated article info the article with the fetched content
          final List<ArticleEntity> updatedArticles = List.of(state.topNews!);
          updatedArticles[articleIndex] = updatedArticles[articleIndex]
              .copyWith(
                  fullContent: returnedFullContent.removeExtraSpaces(),
                  fullContentStatus: FullContentStatus.fetched);
          print(
              '${updatedArticles[articleIndex].id}: with ${updatedArticles[articleIndex].fullContentStatus} value should be ${updatedArticles[articleIndex].fullContent}');
          //change the value and define selected article
          emit(state.copyWith(
              selectedArticle: updatedArticles[articleIndex],
              contentLoadStatus: ContentLoadStatus.success,
              topNews: List.of(updatedArticles)));
          print(
              '${state.topNews![articleIndex].id}: has been saved as ${state.topNews![articleIndex].fullContent}');
        }
        //in the category articles
        else if (state.todaysNews!.containsKey(articleCategory)) {
          print('in todays news');
          List<ArticleEntity> categoryArticles =
              state.todaysNews![articleCategory]!;
          articleIndex =
              categoryArticles.indexWhere((article) => article.id == articleId);
          if (articleIndex == -1) {
            emit(state.copyWith(
                contentLoadStatus: ContentLoadStatus.failure,
                contentLoadErrorMessage: CubitErrors.articleNotFound));
            return; // Early return to stop further processing
          }
          //already fetched
          else if (categoryArticles[articleIndex].fullContentStatus.isFetched) {
            emit(state.copyWith(
                contentLoadStatus: ContentLoadStatus.success,
                selectedArticle: categoryArticles[articleIndex]));
            return;
          }

          contentURL = categoryArticles[articleIndex].url;
          contentInfo = categoryArticles[articleIndex].content;
          print(
              'in todays - contentURL: $contentURL - contentInfo $contentInfo');

          //fetched the content
          returnedFullContent = await _newsApi.fetchFullContent(
              contentURL: contentURL, contentInfo: contentInfo);

          print('returnedFullContent: $returnedFullContent');

          // Update the article with the fetched content
          categoryArticles[articleIndex] = categoryArticles[articleIndex]
              .copyWith(
                  fullContent:
                      returnedFullContent.isEmpty ? null : returnedFullContent,
                  fullContentStatus: returnedFullContent.isEmpty
                      ? FullContentStatus.initial
                      : FullContentStatus.fetched);

          //emitting the state
          emit(state.copyWith(
              contentLoadStatus: ContentLoadStatus.success,
              selectedArticle: categoryArticles[articleIndex],
              todaysNews: Map<ArticleCategory, List<ArticleEntity>>.from(
                  state.todaysNews!)));
        }
      } on Exception catch (e) {
        emit(state.copyWith(
            contentLoadStatus: ContentLoadStatus.failure,
            contentLoadErrorMessage: e.toString()));
      } catch (e) {
        emit(state.copyWith(
            contentLoadStatus: ContentLoadStatus.failure,
            contentLoadErrorMessage: e.toString()));
      }
    } else {
      emit(state.copyWith(
          contentLoadStatus: ContentLoadStatus.failure,
          contentLoadErrorMessage: CubitErrors.unknownError));
    }
    print(
        'article body STATE: ${state.contentLoadStatus} - ${state.contentLoadErrorMessage}');
  }

  //crucial to prevent using outdated information
  void resetContentLoadStatus() {
    emit(state.copyWith(
        contentLoadStatus: ContentLoadStatus.initial,
        selectedArticle: null,
        contentLoadErrorMessage: ''));
  }

  void onSourceImageError(String selectedId) {
    int index = state.sources!.indexWhere((item) => item.id == selectedId);

    if (index != -1) {
      List<SourceEntity> updatedList = List.of(state.sources!);
      updatedList[index] =
          updatedList[index].copyWith(isImageFetchAvailable: false);
      print(
          'change image availability must be: ${updatedList[index].isImageFetchAvailable}');
      emit(state.copyWith(sources: List.of(updatedList)));
      print(
          'change image availability is actually:${state.sources![index].id} ${state.sources![index].isImageFetchAvailable}');
    }
  }
}
