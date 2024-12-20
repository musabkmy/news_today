// ignore_for_file: avoid_print

import 'package:mocktail/mocktail.dart';
import 'package:news_api/news_api.dart';
import 'package:news_today/cubit/news_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:test/test.dart';

import 'mock_data.dart';

class MockNewsApi extends Mock implements NewsApi {}

void main() {
  group('News Cubit', () {
    late MockNewsApi mockNewsApi;
    late NewsCubit newsCubit;
    // late FavIconCubit favIconCubit;
    // late String iconUrl;

    setUp(() {
      mockNewsApi = MockNewsApi();
      newsCubit = NewsCubit(mockNewsApi);
      // favIconCubit = FavIconCubit(mockNewsApi);
    });

    blocTest<NewsCubit, NewsState>(
        'emits [NewsState.loading, NewsState.success] when initiate is called and API calls succeed',
        build: () {
          print('mockSourceData.length ${mockSourceData.length}');
          when(() => mockNewsApi.fetchSources())
              .thenAnswer((_) async => mockSourceData);
          when(() => mockNewsApi.fetchTopNews())
              .thenAnswer((_) async => mockTopArticleData);
          when(() => mockNewsApi.fetchTodaysNews(mockSourceData))
              .thenAnswer((_) async => mockTodaysArticles);
          return newsCubit;
        },
        act: (cubit) async {
          await cubit.initiate();
        },
        verify: (cubit) {
          // expect(techArticle.length, 0);
          final categories = cubit.getAvailableCategories();
          expect(categories.length, 5);

          final allArticle = cubit.getCategoryArticles(ArticleCategory.all);
          expect(allArticle.length, 8);

          final healthArticle =
              cubit.getCategoryArticles(ArticleCategory.health);
          expect(healthArticle.length, 2);

          final techArticle =
              cubit.getCategoryArticles(ArticleCategory.technology);
          expect(techArticle.length, 0);
          // await cubit.fetchFullContent(
          //     articleId: '3', articleCategory: ArticleCategory.business);
          // print(getContent);
        },
        expect: () => [
              NewsState(status: NewsStatus.loading),
              NewsState(
                status: NewsStatus.success,
                sources: mockSourceData,
                topNews: mockTopArticleData,
                todaysNews: mockTodaysArticles,
                errorMessage: '',
              ),
            ]);

    blocTest<NewsCubit, NewsState>(
      'check fetching article content',
      build: () {
        print('mockSourceData.length ${mockSourceData.length}');
        when(() => mockNewsApi.fetchSources())
            .thenAnswer((_) async => mockSourceData);
        when(() => mockNewsApi.fetchTopNews())
            .thenAnswer((_) async => mockTopArticleData);
        when(() => mockNewsApi.fetchTodaysNews(mockSourceData))
            .thenAnswer((_) async => mockTodaysArticles);
        when(() => mockNewsApi.fetchFullContent(
                contentURL:
                    'https://www.wired.com/story/in-the-kentucky-mountains-a-bitcoin-mining-dream-becomes-the-stuff-of-nightmares/',
                contentInfo:
                    'contentInfo In both cases, Biofuel claims, the firms shipped equipment from China to its hosting facility in Eastern Kentucky, then walked away with the bitcoin produced, leaving behind hundreds of thousands of … [+2717 chars]'))
            .thenAnswer((_) async =>
                'In both cases, Biofuel claims, the firms shipped equipment from China to its hosting facility in Eastern Kentucky, then walked away with the bitcoin produced, leaving behind hundreds of thousands of dollars in unpaid energy bills and hosting fees.Biofuel reached a settlement with Touzi in early 2022 for \$60,000, but despite having handed back the mining equipment, it claims not to have received the sum it is owed under the agreement.In the still-unresolved spat with VCV, Biofuel received permission from the Martin County Circuit Court in Kentucky to sell off the mining equipment, claims Whites, to recoup a portion of the funds it is owed (she has not confirmed the amount), but she alleges that no damages have yet been awarded. VCV has stopped responding to communications, she claims.Biofuel has since dissolved, put out of business by the failed hosting ventures. “I literally lost my house—I lost everything. It financially ruined me,” says Wes Hamilton, former Biofuel Mining CEO. “I’m just so frustrated about the whole thing.”WIRED contacted VCV and Touzi for comment, but did not receive any response.There are few financial recovery options for companies like Mohawk and Biofuel. The situation is made more difficult, as in the Mohawk case, if they are dealing with so-called special purpose entities. Because they are set up by their parent companies for a single specific business venture, these entities need not be concerned about their long-term ability to operate in the US.“It certainly can be more difficult to recover damages from a non-US counterparty,” says Kim Havlin, a partner in the global commercial litigation practice at law firm White &amp; Case. “There is certainly a risk that an entity that doesn’t need to be in the US may just ignore the case.”Even if the Kentucky facility owners win out in court, it could be difficult to collect any damages awarded. “A judgment is essentially a piece of paper. Any judgment needs to be turned into assets or cash in order to be valuable,” says Havlin. If the opposing party refuses to pay up and has no US assets to collect against, sometimes that isn’t possible.Almost a year after the dispute began, the Mohawk case is stuck in legal limbo. In a setback for Mohawk, the presiding judge recently denied its motion to dismiss HBT’s complaint, on the basis that it had failed to sufficiently back up its argument. The judge also pushed Mohawk’s countersuit into arbitration, a forum for resolving disputes privately instead of in open court. Non-US parties tend to prefer arbitration as a way to “remove a home forum from both sides,” explains Havlin. “You can pick an arbitral seat in neither country as a means of creating a neutral playing field.” A parallel federal court hearing is set for December to consider whether an injunction should be imposed on Mohawk, preventing it from selling off the remaining HBT equipment in its posses');
        return newsCubit;
      },
      act: (cubit) async {
        await cubit.initiate();
        await cubit.fetchFullContent(
            articleId: '3', articleCategory: ArticleCategory.business);
      },
      verify: (cubit) {
        final allArticle = cubit.getCategoryArticles(ArticleCategory.business);
        print(allArticle.first.fullContent);
        print(allArticle[1].content);
      },
    );

    // blocTest<NewsCubit, NewsState>(
    //     'emits [NewsState.loading, NewsState.failure] when initiate is called and API calls failed',
    //     build: () {
    //       print('mockSourceData.length ${mockSourceData.length}');
    //       when(() => mockNewsApi.fetchSources())
    //           .thenAnswer((_) async => mockSourceData);
    //       when(() => mockNewsApi.fetchTopNews())
    //           .thenAnswer((_) async => mockTopArticleData);
    //       when(() => mockNewsApi.fetchTodaysNews(mockSourceData))
    //           .thenAnswer((_) async => throw TodaysArticlesNotFoundException());
    //       return newsCubit;
    //     },
    //     act: (cubit) => cubit.initiate(),
    //     expect: () => <NewsState>[
    //           NewsState(status: NewsStatus.loading),
    //           NewsState(
    //             status: NewsStatus.failure,
    //             errorMessage: '',
    //           ),
    //         ]);

    // blocTest<FavIconCubit, FavIconState>(
    //   'test if fav icon should be loaded when ',
    //   setUp: () {
    //     iconUrl = 'https://arstechnica.com/favicon.ico';
    //   },
    //   build: () {
    //     when(() => mockNewsApi.hasAFavIcon(iconUrl))
    //         .thenAnswer((_) async => true);
    //     return favIconCubit;
    //   },
    //   act: (cubit) => cubit.useFavIcon(iconUrl),
    //   expect: () => [
    //     FavIconState(isLoading: true),
    //     FavIconState(isLoading: true, isUsingUrl: true, faviconUrl: iconUrl),
    //     FavIconState(isLoading: false, isUsingUrl: true, faviconUrl: iconUrl),
    //   ],
    // );

    tearDown(() {
      newsCubit.close();
    });
  });
}
