// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeData themeData;
  ThemeState({required this.themeData});

  @override
  List<Object> get props => [];

  ThemeState copyWith({
    required ThemeData themeData,
  }) {
    return ThemeState(
      themeData: this.themeData,
    );
  }
}
