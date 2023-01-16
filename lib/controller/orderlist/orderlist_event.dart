part of 'orderlist_bloc.dart';

@freezed
class OrderlistEvent with _$OrderlistEvent {
  const factory OrderlistEvent.started() = _Started;
  const factory OrderlistEvent.orderList() = _OrderList;
}