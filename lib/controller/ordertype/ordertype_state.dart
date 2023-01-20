part of 'ordertype_bloc.dart';

@freezed
class OrdertypeState with _$OrdertypeState {
  const factory OrdertypeState.initial() = _Initial;
  const factory OrdertypeState.loading() = _Loading;
  const factory OrdertypeState.loaded({required OrderTypeModel ordertype}) =
      _Loaded;
  const factory OrdertypeState.error({required String message}) = _Error;
}
