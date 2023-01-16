part of 'orderdetails_bloc.dart';

@freezed
class OrderdetailsState with _$OrderdetailsState {
  const factory OrderdetailsState.initial() = _Initial;
  const factory OrderdetailsState.loading() = _Loading;
  const factory OrderdetailsState.success(
      {required List<OrderDetailsModel> orderDetails}) = _Success;
  const factory OrderdetailsState.failure({required String message}) = _Failure;
}
