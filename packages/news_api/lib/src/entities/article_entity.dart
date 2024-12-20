// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'source_basic.dart';

enum FullContentStatus { initial, fetched }

extension FullContentStatusExt on FullContentStatus {
  bool get isInitial => this == FullContentStatus.initial;
  bool get isFetched => this == FullContentStatus.fetched;
  // bool get isFailed => this == FullContentStatus.failed;
}

class ArticleEntity {
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
  String? fullContent;
  FullContentStatus fullContentStatus;

  ArticleEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.source,
    required this.isSavedArticle,
    this.fullContent,
    this.fullContentStatus = FullContentStatus.initial,
  });

  ArticleEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? author,
    String? url,
    String? urlToImage,
    String? publishedAt,
    String? content,
    SourceBasic? source,
    bool? isSavedArticle,
    String? fullContent,
    FullContentStatus? fullContentStatus,
  }) {
    return ArticleEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
      source: source ?? this.source,
      isSavedArticle: isSavedArticle ?? this.isSavedArticle,
      fullContent: fullContent ?? this.fullContent,
      fullContentStatus: fullContentStatus ?? this.fullContentStatus,
    );
  }
}
