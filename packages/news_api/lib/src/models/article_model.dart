// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:news_api/src/utils/string_extension.dart';
import 'package:uuid/uuid.dart';

import '../entities/article_entity.dart';
import '../entities/source_basic.dart';

class ArticleModel {
  // static int _liveArticleIdCounter = 0; // Counter for live articles
  static const Uuid _uuid = Uuid(); // UUID generator

  final String id; // Unique identifier for the article
  final String title; // Title of the article
  final String description; // Short description of the article
  final String author; // Author of the article
  final String url; // URL of the article
  final String urlToImage; // URL to the article's image
  final String? publishedAt; // Publication date of the article
  final String content; // Content of the article
  final SourceBasic source; // Source of the article
  bool isSavedArticle;

  ArticleModel({
    required this.title,
    required this.description,
    required this.author,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.source,
    this.isSavedArticle = false,
  }) : id = _uuid.v4();

  // Method to generate a unique ID for saved articles
  String generateSavedArticleId() {
    return _uuid.v4(); // Generate a UUID for saved articles
  }

  ArticleEntity toEntity() {
    return ArticleEntity(
      id: id,
      title: title,
      description: description,
      author: author,
      url: url,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
      content: content,
      source: source,
      isSavedArticle: isSavedArticle,
    );
  }

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      title: json['title'].toString().valueOrEmpty,
      description: json['description'].toString().valueOrEmpty,
      author: json['author'].toString().valueOrEmpty, // Handle missing author
      url: json['url'].toString().valueOrEmpty,
      urlToImage: json['urlToImage'].toString().valueOrEmpty,
      publishedAt: json['publishedAt'].toString().isNullOrEmpty
          ? ''
          : json['publishedAt'].toString(),
      content: json['content'].toString().valueOrEmpty,
      source: SourceBasic(
        id: json['source']['id'].toString().valueOrEmpty,
        name: json['source']['name'].toString().valueOrEmpty,
      ),
    );
  }
}
