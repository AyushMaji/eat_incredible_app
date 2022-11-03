part of 'cart_iteams_bloc.dart';

@freezed
class CartIteamsEvent with _$CartIteamsEvent {
  const factory CartIteamsEvent.started() = _Started;
  const factory CartIteamsEvent.getCartIteams() = _GetCartIteams;
}