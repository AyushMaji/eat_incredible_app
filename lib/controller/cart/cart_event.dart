part of 'cart_bloc.dart';

@freezed
class CartEvent with _$CartEvent {
  const factory CartEvent.started() = _Started;
  const factory CartEvent.addToCart(String productid) = _AddToCart;
  const factory CartEvent.removeCart(String productid) = _RemoveCart;
}