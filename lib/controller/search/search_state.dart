part of 'search_bloc.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = _Initial;
  const factory SearchState.loading() = _Loading;
  const factory SearchState.success({required List search}) = _Success;

  const factory SearchState.failure({required String message}) = _Failure;
}
