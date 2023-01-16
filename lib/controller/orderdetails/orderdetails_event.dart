part of 'orderdetails_bloc.dart';

@freezed
class OrderdetailsEvent with _$OrderdetailsEvent {
  const factory OrderdetailsEvent.started() = _Started;
  const factory OrderdetailsEvent.orderDetails({required String orderId}) =
      _OrderDetails;
}
