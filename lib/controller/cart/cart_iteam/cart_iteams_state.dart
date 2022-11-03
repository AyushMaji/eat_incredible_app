part of 'cart_iteams_bloc.dart';

@freezed
class CartIteamsState with _$CartIteamsState {
  const factory CartIteamsState.initial() = _Initial;
  const factory CartIteamsState.loading() = _Loading;
  const factory CartIteamsState.loaded(
      {required List<CartIteamModel> cartIteamList}) = _Loaded;
  const factory CartIteamsState.error({required String message}) = _Error;
}
