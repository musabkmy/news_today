// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:news_api/news_api.dart';

// part 'icon_fav_state.dart';

// class FavIconCubit extends Cubit<FavIconState> {
//   FavIconCubit(this._newsApi) : super(FavIconState());
//   final NewsApi _newsApi;

//   Future<void> useFavIcon(String url) async {
//     emit(state.copyWith(isLoading: true));
//     bool isUsingUrl = false;
//     try {
//       isUsingUrl = await _newsApi.hasAFavIcon(url);
//       if (isUsingUrl) {
//         emit(state.copyWith(
//           faviconUrl: url,
//           isUsingUrl: true,
//         ));
//       } else {
//         emit(state.copyWith(isUsingUrl: false));
//       }
//     } catch (e) {
//       emit(state.copyWith(isUsingUrl: false));
//     } finally {
//       emit(state.copyWith(isLoading: false));
//     }
//   }
// }
