// ignore_for_file: prefer_const_constructors

import 'package:news_api/news_api.dart';

final List<SourceEntity> mockSourceData = [
  SourceEntity(
    id: 'source7',
    name: 'Source 7',
    description: 'Source 7 Description',
    favIconURL: 'https://example.com/favicon7.ico',
    category: ArticleCategory.health,
  ),
  SourceEntity(
    id: 'source8',
    name: 'Source 8',
    description: 'Source 8 Description',
    favIconURL: 'https://example.com/favicon8.ico',
    category: ArticleCategory.health,
  ),
  SourceEntity(
    id: 'source4',
    name: 'Source 4',
    description: 'Source 4 Description',
    favIconURL: 'https://example.com/favicon4.ico',
    category: ArticleCategory.business,
  ),
  SourceEntity(
    id: 'source5',
    name: 'Source 5',
    description: 'Source 5 Description',
    favIconURL: 'https://example.com/favicon5.ico',
    category: ArticleCategory.entertainment,
  ),
  SourceEntity(
    id: 'source6',
    name: 'Source 6',
    description: 'Source 6 Description',
    favIconURL: 'https://example.com/favicon6.ico',
    category: ArticleCategory.entertainment,
  ),
  SourceEntity(
    id: 'source1',
    name: 'Source 1',
    description: 'Source 1 Description',
    favIconURL: 'https://example.com/favicon1.ico',
    category: ArticleCategory.general,
  ),
  SourceEntity(
    id: 'source10',
    name: 'Source 10',
    description: 'Source 10 Description',
    favIconURL: 'https://example.com/favicon1.ico',
    category: ArticleCategory.sports,
  ),
  SourceEntity(
    id: 'source2',
    name: 'Source 2',
    description: 'Source 2 Description',
    favIconURL: 'https://example.com/favicon2.ico',
    category: ArticleCategory.general,
  ),
  SourceEntity(
    id: 'source3',
    name: 'Source 3',
    description: 'Source 3 Description',
    favIconURL: 'https://example.com/favicon3.ico',
    category: ArticleCategory.business,
  ),
];

final List<ArticleEntity> mockTopArticleData = [
  ArticleEntity(
    id: '1',
    title: 'Mock Article 1',
    description: 'Description for Mock Article 1',
    author: 'Author 1',
    url: 'https://article1.com',
    urlToImage: 'https://article1.com/image.jpg',
    publishedAt: '',
    content: 'Content for Mock Article 1',
    source: SourceBasic(id: 'source1', name: 'Mock Source 1'),
    isSavedArticle: false,
  ),
  ArticleEntity(
    id: '2',
    title: 'Mock Article 2',
    description: 'Description for Mock Article 2',
    author: 'Author 2',
    url: 'https://article2.com',
    urlToImage: 'https://article2.com/image.jpg',
    publishedAt: '',
    content: 'Content for Mock Article 2',
    source: SourceBasic(id: 'source2', name: 'Mock Source 2'),
    isSavedArticle: true,
  ), // Add more mock data as needed
];

final Map<ArticleCategory, List<ArticleEntity>> mockTodaysArticles = {
  ArticleCategory.business: [
    ArticleEntity(
      id: '3',
      title: 'Business Insights',
      description: 'An in-depth look at the financial markets today.',
      author: 'Author 3',
      url:
          "https://www.wired.com/story/in-the-kentucky-mountains-a-bitcoin-mining-dream-becomes-the-stuff-of-nightmares/",
      urlToImage: 'https://example.com/business1.jpg',
      publishedAt: '',
      content:
          'In both cases, Biofuel claims, the firms shipped equipment from China to its hosting facility in Eastern Kentucky, then walked away with the bitcoin produced, leaving behind hundreds of thousands of … [+2717 chars]',
      source: SourceBasic(id: 'source3', name: 'Source 3'),
      isSavedArticle: false,
    ),
    ArticleEntity(
      id: '4',
      title: 'Startup Success Stories',
      description: 'How a small business became a major player in the market.',
      author: 'Author 4',
      url: 'https://example.com/business2',
      urlToImage: 'https://example.com/business2.jpg',
      publishedAt: '',
      content: 'Detailed content on the startup success story.',
      source: SourceBasic(id: 'source4', name: 'Source 4'),
      isSavedArticle: true,
    ),
  ],
  ArticleCategory.health: [
    ArticleEntity(
      id: '7',
      title: 'Health and Wellness Tips',
      description: 'How to stay healthy and fit.',
      author: 'Author 7',
      url: 'https://example.com/health1',
      urlToImage: 'https://example.com/health1.jpg',
      publishedAt: '',
      content: 'Full article on health and wellness tips.',
      source: SourceBasic(id: 'source7', name: 'Source 7'),
      isSavedArticle: false,
    ),
    ArticleEntity(
      id: '8',
      title: 'New Medical Breakthroughs',
      description: 'Recent advancements in medical science.',
      author: 'Author 8',
      url: 'https://example.com/health2',
      urlToImage: 'https://example.com/health2.jpg',
      publishedAt: '',
      content: 'Detailed content on medical breakthroughs.',
      source: SourceBasic(id: 'source8', name: 'Source 8'),
      isSavedArticle: true,
    ),
  ],
  ArticleCategory.general: [
    ArticleEntity(
      id: '1',
      title: 'Breaking News in General',
      description:
          'A significant event happened today in the general category.',
      author: 'Author 1',
      url: 'https://example.com/general1',
      urlToImage: 'https://example.com/general1.jpg',
      publishedAt: '',
      content: 'Full content about the general event.',
      source: SourceBasic(id: 'source1', name: 'Source 1'),
      isSavedArticle: false,
    ),
    ArticleEntity(
      id: '2',
      title: 'General Updates',
      description: 'Latest updates from around the world.',
      author: 'Author 2',
      url: 'https://example.com/general2',
      urlToImage: 'https://example.com/general2.jpg',
      publishedAt: '',
      content:
          'Detailed content about the latest updates in the general category.',
      source: SourceBasic(id: 'source2', name: 'Source 2'),
      isSavedArticle: true,
    ),
  ],
  ArticleCategory.entertainment: [
    ArticleEntity(
      id: '5',
      title: 'Entertainment Buzz',
      description: 'Latest gossip and news in the entertainment world.',
      author: 'Author 5',
      url: 'https://example.com/entertainment1',
      urlToImage: 'https://example.com/entertainment1.jpg',
      publishedAt: '',
      content: 'Full article on the latest entertainment buzz.',
      source: SourceBasic(id: 'source5', name: 'Source 5'),
      isSavedArticle: false,
    ),
    ArticleEntity(
      id: '6',
      title: 'Movie Reviews',
      description: 'Critics review the latest blockbuster movies.',
      author: 'Author 6',
      url: 'https://example.com/entertainment2',
      urlToImage: 'https://example.com/entertainment2.jpg',
      publishedAt: '',
      content: 'Detailed content on movie reviews.',
      source: SourceBasic(id: 'source6', name: 'Source 6'),
      isSavedArticle: true,
    ),
  ],
};
