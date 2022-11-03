part of 'cart_details_bloc.dart';

@freezed
class CartDetailsState with _$CartDetailsState {
  const factory CartDetailsState.initial() = _Initial;
  const factory CartDetailsState.loading() = _Loading;
  const factory CartDetailsState.loaded(
      {required CartDetailModel cartDetailModel}) = _Loaded;
  const factory CartDetailsState.error({required String message}) = _Error;
}
