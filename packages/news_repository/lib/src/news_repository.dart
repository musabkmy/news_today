import 'package:news_api/news_api.dart';

/// {@template news_repository}
/// A repository that handles `news` related requests.
/// {@endtemplate}
class NewsRepository {
  /// {@macro news_repository}
  const NewsRepository({
    required NewsApi newsApi,
  }) : _newsApi = newsApi;

  final NewsApi _newsApi;

  Future<List<SourceEntity>> fetchSources() => _newsApi.fetchSources();
  Future<List<ArticleEntity>> fetchBreakingNews() => _newsApi.fetchTopNews();
  Future<Map<ArticleCategory, List<ArticleEntity>>> fetchTodaysNews(
          List<SourceEntity> sourcesEntity) =>
      _newsApi.fetchTodaysNews(sourcesEntity);
  Future<void> saveNews(List<ArticleModel> news) => _newsApi.saveNews(news);
}
