part of 'ordertype_bloc.dart';

@freezed
class OrdertypeEvent with _$OrdertypeEvent {
  const factory OrdertypeEvent.started() = _Started;
  const factory OrdertypeEvent.getOrdertype(String paymentType) = _GetOrdertype;
}
