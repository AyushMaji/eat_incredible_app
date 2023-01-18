import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/model/productlist/productlist_model.dart';
import 'package:eat_incredible_app/repo/search.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'search_event.dart';
part 'search_state.dart';
part 'search_bloc.freezed.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const _Initial()) {
    on<_SearchKey>((event, emit) async {
      emit(const _Loading());
      var result = await SearchRepo().searchKey(event.search);
      result.when(
        success: (data) {
          Logger().i(data);
          emit(_Success(search: data));
        },
        failure: (error) {
          emit(_Failure(message: error.toString()));
        },
      );
    });
    on<_TrendingSearch>((event, emit) async {
      emit(const _Loading());
      var result = await SearchRepo().treadingSearch();
      result.when(
        success: (data) {
          Logger().i(data);
          emit(_Success(search: data));
        },
        failure: (error) {
          emit(_Failure(message: error.toString()));
        },
      );
    });

    on<_SearchProduct>((event, emit) async {
      List<ProductlistModel> searchData = [];
      emit(const _Loading());
      var result = await SearchRepo().searchProduct(event.search);
      result.when(
        success: (data) {
          for (var i = 0; i < data.length; i++) {
            searchData.add(ProductlistModel.fromJson(data[i]));
          }
          Logger().i(searchData);
          emit(_Success(search: searchData));
        },
        failure: (error) {
          emit(_Failure(message: error.toString()));
        },
      );
    });
  }
}
