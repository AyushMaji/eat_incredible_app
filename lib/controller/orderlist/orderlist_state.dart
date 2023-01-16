part of 'orderlist_bloc.dart';

@freezed
class OrderlistState with _$OrderlistState {
  const factory OrderlistState.initial() = _Initial;
  const factory OrderlistState.loading() = _Loading;
  const factory OrderlistState.loaded(List<OrderModel> orderList) = _Loaded;
  const factory OrderlistState.failure(String msg) = _Failure;
}
