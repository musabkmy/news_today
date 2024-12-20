// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:news_api/news_api.dart';

class SourceEntity implements SourceBase {
  @override
  final String? id;
  @override
  final String? name;
  final String? description;
  final String? favIconURL;
  final ArticleCategory? category;
  bool isImageFetchAvailable;
  // final String language;
  // final String country;

  SourceEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.favIconURL,
    required this.category,
    this.isImageFetchAvailable = true,
    // required this.language,
    // required this.country,
  });

  factory SourceEntity.defaultInstance() {
    return SourceEntity(
        id: '',
        name: '',
        description: '',
        favIconURL: '',
        category: ArticleCategory.unknown,
        isImageFetchAvailable: true);
  }

  SourceEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? favIconURL,
    ArticleCategory? category,
    bool? isImageFetchAvailable,
  }) {
    return SourceEntity(
      id: this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      favIconURL: favIconURL ?? this.favIconURL,
      category: category ?? this.category,
      isImageFetchAvailable:
          isImageFetchAvailable ?? this.isImageFetchAvailable,
    );
  }
}
