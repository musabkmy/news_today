import 'package:news_api/news_api.dart';

class SourceBasic implements SourceBase {
  @override
  final String? id;
  @override
  final String? name;

  SourceBasic({required this.id, required this.name});
}
