part of 'search_bloc.dart';

@freezed
class SearchEvent with _$SearchEvent {
  const factory SearchEvent.started() = _Started;
  const factory SearchEvent.searchProduct({required String search}) =
      _SearchProduct;
  const factory SearchEvent.searchKey({required String search}) = _SearchKey;
  const factory SearchEvent.trendingSearch() = _TrendingSearch;
}
