// ignore_for_file: prefer_const_constructors_in_immutables

part of 'news_cubit.dart';

enum NewsStatus { initial, loading, success, failure }

///handling scenarios where the article may not be found in the state
///must be reinitialized to prevent using outdated or irrelevant information
enum ContentLoadStatus { initial, loading, success, failure }

extension NewsStatusX on NewsStatus {
  bool get isInitial => this == NewsStatus.initial;
  bool get isLoading => this == NewsStatus.loading;
  bool get isSuccess => this == NewsStatus.success;
  bool get isFailure => this == NewsStatus.failure;
}

extension ContentLoadStatusX on ContentLoadStatus {
  bool get isInitial => this == ContentLoadStatus.initial;
  bool get isLoading => this == ContentLoadStatus.loading;
  bool get isSuccess => this == ContentLoadStatus.success;
  bool get isFailure => this == ContentLoadStatus.failure;
}

// ignore: must_be_immutable
final class NewsState extends Equatable {
  NewsState({
    this.status = NewsStatus.initial,
    this.sources,
    this.topNews,
    this.todaysNews,
    this.errorMessage = '',
    this.contentLoadStatus = ContentLoadStatus.initial,
    this.contentLoadErrorMessage = '',
    this.selectedArticle,
  });
  final NewsStatus status;
  final List<SourceEntity>? sources;
  final List<ArticleEntity>? topNews;
  final Map<ArticleCategory, List<ArticleEntity>>? todaysNews;
  final String errorMessage;
  final ContentLoadStatus contentLoadStatus;
  final String contentLoadErrorMessage;
  ArticleEntity? selectedArticle;

  NewsState copyWith({
    NewsStatus? status,
    List<SourceEntity>? sources,
    List<ArticleEntity>? topNews,
    Map<ArticleCategory, List<ArticleEntity>>? todaysNews,
    String? errorMessage,
    ContentLoadStatus? contentLoadStatus,
    String? contentLoadErrorMessage,
    ArticleEntity? selectedArticle,
  }) {
    return NewsState(
      status: status ?? this.status,
      sources: sources ?? this.sources,
      topNews: topNews ?? this.topNews,
      todaysNews: todaysNews ?? this.todaysNews,
      errorMessage: errorMessage ?? this.errorMessage,
      contentLoadStatus: contentLoadStatus ?? this.contentLoadStatus,
      contentLoadErrorMessage:
          contentLoadErrorMessage ?? this.contentLoadErrorMessage,
      selectedArticle: selectedArticle ?? this.selectedArticle,
    );
  }

  @override
  List<Object?> get props => [
        status,
        sources,
        topNews,
        todaysNews,
        errorMessage,
        contentLoadStatus,
        contentLoadErrorMessage,
        selectedArticle,
      ];
}
