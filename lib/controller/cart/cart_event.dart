part of 'cart_bloc.dart';

@freezed
class CartEvent with _$CartEvent {
  const factory CartEvent.started() = _Started;
  const factory CartEvent.addToCart({required String productid}) = _AddToCart;
  const factory CartEvent.removeCart({required String productid}) = _RemoveCart;
}
