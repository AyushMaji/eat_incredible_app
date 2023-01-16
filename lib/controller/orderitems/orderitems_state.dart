part of 'orderitems_bloc.dart';

@freezed
class OrderitemsState with _$OrderitemsState {
  const factory OrderitemsState.initial() = _Initial;
  const factory OrderitemsState.loading() = _Loading;
  const factory OrderitemsState.success(
      {required List<OrderItemsModel> orderItems}) = _Success;

  const factory OrderitemsState.failure({required String message}) = _Failure;
}
