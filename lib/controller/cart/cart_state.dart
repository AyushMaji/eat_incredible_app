part of 'cart_bloc.dart';

@freezed
class CartState with _$CartState {
  const factory CartState.initial() = _Initial;
  const factory CartState.loading({required String productId}) = _Loading;
  const factory CartState.success(
      {required String message, required String productId}) = _Success;
  const factory CartState.failure({required String message}) = _Failure;
}
