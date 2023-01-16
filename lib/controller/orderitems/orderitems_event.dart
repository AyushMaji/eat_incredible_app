part of 'orderitems_bloc.dart';

@freezed
class OrderitemsEvent with _$OrderitemsEvent {
  const factory OrderitemsEvent.started() = _Started;
  const factory OrderitemsEvent.orderItems({required String orderId}) =
      _OrderItems;
}
