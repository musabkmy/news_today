// ignore_for_file: collection_methods_unrelated_type, avoid_print
import 'package:news_api/news_api.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  NewsOpenApi newsApi = NewsOpenApi();

  test('Today\'s News', () async {
    final List<SourceEntity> sources = await newsApi.fetchSources();
    final Map<ArticleCategory, List<ArticleEntity>> response =
        await newsApi.fetchTodaysNews(sources);
    print('Length: ${response.values.length}');
    if (response.containsKey(ArticleCategory.business)) {
      for (var element in response[ArticleCategory.business]!) {
        print('Element ${element.title}');
      }
    } else {
      print('Do not contain the item');
    }
    // final response = await newsApiService.getSources();
    // List<SourceModel> sources = [];
    // if (response['status'] == 'ok') {
    //   List<dynamic> sourcesResponse = response['sources'];
    //   for (int i = 0; i < sourcesResponse.length; i++) {
    //     sources.add(SourceModel.fromJson(sourcesResponse[i]));
    //   }
    // }
    // final response2 = await newsApiService.getTodaysNews(getSources(sources));
    // ArticleEntity articleEntity =
    //     ArticleModel.fromJson(response2['articles'][1]).fromModelToEntity();
    // print(articleEntity.source.name);
  });

  test('loading favIcon', () async {
    const imageUrl = 'https://nasracentre.com//favicon.ico';
    try {
      final response = await http.head(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        print('true');
      } else {
        print('failed');
      }
    } catch (e) {
      throw Exception();
    }
  });

  test('opening article url', () {});

  group('Fetching article Content', () {
    test('check the validity of contentInfo', () async {
      bool isValid;
      String? contentStart;
      int? remainChar;
      (
        isValid,
        contentStart,
        remainChar
      ) = extractContentStartAndRemainingChars(
          'On the campaign trail, Trump went out of his way to court their favor. In July, speaking to thousands of bitcoiners at a conference in Nashville, Tennessee, Trump duly sang from the bitcoin hymn shee… [+2014 chars]');
      print('''isValid: $isValid ,
        contentStart; $contentStart,
        remainChar; $remainChar''');

      if (isValid) {
        await fetchAndExtractCleanContent(
          "https://www.wired.com/story/trump-crypto-support/",
          contentStart!,
          remainChar!,
        );
      }
    });

    test('get the article content', () async {
      await newsApi.fetchFullContent(
          contentURL:
              'https://www.nbcsports.com/nfl/profootballtalk/rumor-mill/news/kyle-shanahan-stays-coy-about-christian-mccaffrey',
          contentInfo:
              'The season began with the 49ers playing games about the availability of running back Christian McCaffrey. Now that hes inching toward his 2024 debut, the games continue. Asked by reporters when a de… [+1696 chars]');
    });
  });
}
