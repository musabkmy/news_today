import 'package:news_api/news_api.dart';

abstract class NewsApi {
  Future<List<SourceEntity>> fetchSources();
  Future<bool> isFavIconAvailable(String url);
  Future<List<ArticleEntity>> fetchTopNews();
  Future<Map<ArticleCategory, List<ArticleEntity>>> fetchTodaysNews(
      List<SourceEntity> sourcesEntity);
  Future<String> fetchFullContent(
      {required String contentURL, required String contentInfo});
  Future<void> saveNews(List<ArticleModel> news);
}

///Networking Exception
class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'There is no network connection']);
}

/// Exception thrown when fetching sources fails.
class FetchSourcesFailure implements Exception {}

/// Exception thrown when not finding sources.
class SourcesNotFoundException implements Exception {}

/// Exception thrown when fetching articles fails.
class FetchTopArticlesFailure implements Exception {}

/// Exception thrown when not finding articles.
class TopArticlesNotFoundException implements Exception {}

/// Exception thrown when fetching articles fails.
class FetchTodaysArticlesFailure implements Exception {}

/// Exception thrown when not finding articles.
class TodaysArticlesNotFoundException implements Exception {}

///Fetching Article content exception
class FetchArticleContentException implements Exception {
  final String message;
  FetchArticleContentException([this.message = 'Content couldn\'t be fetched']);
}
