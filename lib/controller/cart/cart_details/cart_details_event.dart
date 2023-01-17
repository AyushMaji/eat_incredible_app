part of 'cart_details_bloc.dart';

@freezed
class CartDetailsEvent with _$CartDetailsEvent {
  const factory CartDetailsEvent.started() = _Started;
  const factory CartDetailsEvent.getCartDetails({required String coupon}) =
      _GetCartDetails;
}
