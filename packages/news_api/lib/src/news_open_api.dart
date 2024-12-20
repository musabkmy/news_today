// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart';
import 'package:sanitize_html/sanitize_html.dart';
import 'package:news_api/config/config.dart';
import 'package:news_api/news_api.dart';

/// {@template news_open_api}
/// API to fetch news from various sources across multiple categories.
/// {@endtemplate}
class NewsOpenApi implements NewsApi {
  final String apiKey = Config.newsApiKey;
  final String language = 'en';
  final String baseUrl = "https://newsapi.org/v2";

  /// {@macro news_open_api}
  NewsOpenApi();

  @override
  Future<List<SourceEntity>> fetchSources() async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/top-headlines/sources?apiKey=$apiKey&language=$language'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (!jsonResponse.containsKey('sources')) {
          throw SourcesNotFoundException();
        }
        final List<dynamic> sourcesJson = jsonResponse['sources'];

        if (sourcesJson.isEmpty) {
          throw SourcesNotFoundException();
        }
        print('sourcesJson: $sourcesJson');
        final List<SourceModel> sourcesModel = sourcesJson
            .map((response) =>
                SourceModel.fromJson(response as Map<String, dynamic>))
            .toList()
            .sublist(0, sourcesJson.length >= 20 ? 20 : sourcesJson.length);
        // remove an wanted sources
        sourcesModel
            .removeWhere((element) => excludedSourcesIds.contains(element.id));
        return sourcesModel.map((element) => element.toEntity()).toList();
        // final List<SourceEntity> sourcesEntity = [];
        // for (final item in sourcesModel) {
        //   sourcesEntity.add(item.toEntity().copyWith(
        //       isImageFetchAvailable:
        //           await isFavIconAvailable(item.favIconURL)));
        // }
        // return sourcesEntity;
      } else {
        throw FetchSourcesFailure();
      }
    } on NetworkException catch (e) {
      throw NetworkException('Network Exception: ${e.message}');
    } on SourcesNotFoundException catch (_) {
      throw SourcesNotFoundException();
    } on FetchSourcesFailure catch (_) {
      throw FetchSourcesFailure();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<bool> isFavIconAvailable(String? url) async {
    if (url == null) return false;
    try {
      // Attempt to fetch the image from the provided URL
      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on NetworkException catch (_) {
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ArticleEntity>> fetchTopNews() async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/top-headlines?apiKey=$apiKey&language=$language'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (!jsonResponse.containsKey('articles')) {
          throw TopArticlesNotFoundException();
        }
        final List<dynamic> articlesJson = jsonResponse['articles'];

        final List<ArticleModel> articlesModel = articlesJson
            .map((response) =>
                ArticleModel.fromJson(response as Map<String, dynamic>))
            .toList();

        articlesModel.removeWhere((element) => element.title == '[Removed]');
        if (articlesModel.isEmpty) {
          throw TopArticlesNotFoundException();
        }
        return articlesModel.map((element) => element.toEntity()).toList();
      } else {
        throw FetchTopArticlesFailure();
      }
    } on NetworkException catch (e) {
      throw NetworkException(e.message);
    } on TopArticlesNotFoundException catch (_) {
      throw TopArticlesNotFoundException();
    } on FetchSourcesFailure catch (_) {
      throw FetchSourcesFailure();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<Map<ArticleCategory, List<ArticleEntity>>> fetchTodaysNews(
      List<SourceEntity> sourcesEntity) async {
    //create sources query
    String sources = getSources(sourcesEntity);
    if (sources.isEmpty) {
      throw SourcesNotFoundException();
    }
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/everything?apiKey=$apiKey&language=$language&sources=$sources'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (!jsonResponse.containsKey('articles')) {
          throw TodaysArticlesNotFoundException();
        }
        final List<dynamic> articlesJson = jsonResponse['articles'];

        if (articlesJson.isEmpty) {
          throw TodaysArticlesNotFoundException();
        }

        //json to model
        final List<ArticleModel> articlesModel = articlesJson
            .map((response) =>
                ArticleModel.fromJson(response as Map<String, dynamic>))
            .toList();
        //model to entity
        final List<ArticleEntity> articlesEntity =
            articlesModel.map((element) => element.toEntity()).toList();

        //create a list of categories depending on th sources ArticleCategory
        final Map<ArticleCategory, List<ArticleEntity>> categorizedArticles =
            {};
        SourceEntity selectedSource;
        for (var article in articlesEntity) {
          selectedSource = sourcesEntity.firstWhere(
              (source) => source.id == article.source.id,
              orElse: () => SourceEntity.defaultInstance());
          if (selectedSource != SourceEntity.defaultInstance()) {
            categorizedArticles
                .putIfAbsent(selectedSource.category!, () => [])
                .add(article);
          }
        }

        return categorizedArticles;
      } else {
        throw FetchTodaysArticlesFailure();
      }
    } on NetworkException catch (e) {
      throw NetworkException(e.message);
    } on TodaysArticlesNotFoundException catch (_) {
      throw TodaysArticlesNotFoundException();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<String> fetchFullContent(
      {required String contentURL, required String contentInfo}) async {
    print('in data layer');

    bool isValid;
    String? contentStart;
    int? remainChar;

//check for a url to be matched to news open api content link and return the url and the remaining chars to be retrieved
    (isValid, contentStart, remainChar) =
        extractContentStartAndRemainingChars(contentInfo);
    if (!isValid || contentStart!.isEmpty) {
      throw FetchArticleContentException('Content info is not in right form');
    }

    try {
      final response = await http.get(Uri.parse(contentURL));

      if (response.statusCode == 200) {
        final rawContent = response.body;
        print('200');
        // Parse HTML and extract text
        Document document = html_parser.parse(rawContent);
        final parsedText = document.body?.text ?? '';
        final cleanedContent = sanitizeHtml(parsedText);

        // print('Extracted and cleaned content:');
        // print('Cleaned: ${cleanedContent.substring(1000, 1400)}');

        // Search for the start string in the entire body
        int startIndex = cleanedContent.indexOf(
            contentStart.substring(0, getSearchLimit(cleanedContent.length)));
        if (startIndex != -1) {
          // Calculate the end index based on the provided length
          int endIndex = startIndex + contentStart.length + remainChar!;
          if (endIndex > cleanedContent.length) {
            endIndex = cleanedContent.length;
            // print('endIndex out of bound.');
          }
          print('got it!!');
          print(cleanedContent.substring(startIndex, endIndex));
          return cleanedContent.substring(startIndex, endIndex);
        } else {
          throw FetchArticleContentException();
          // print('Start string not found in the content.');
        }
      } else {
        print('no 200');
        throw NetworkException();
      }
    } on NetworkException catch (e) {
      throw NetworkException(e.message);
    } on FetchArticleContentException catch (e) {
      throw FetchArticleContentException(e.message);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Future<void> saveNews(List<ArticleModel> news) {
    // TODO: implement saveNews
    throw UnimplementedError();
  }
}
