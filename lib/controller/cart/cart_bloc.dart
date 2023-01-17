import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/repo/cart_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_event.dart';
part 'cart_state.dart';
part 'cart_bloc.freezed.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const _Initial()) {
    on<_AddToCart>((event, emit) async {
      emit(_Loading(productId: event.productid));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var result = await CartRepo.addToCart(event.productid);
      result.when(
        success: (data) {
          if (data['status'] == 200) {
            data['guest'] != null
                ? prefs.setString('guest_id', data['guest'].toString())
                : null;

            emit(
                _Success(message: data['message'], productId: event.productid));
          } else {
            emit(_Failure(message: data['message']));
          }
        },
        failure: (error) {
          emit(_Failure(message: error));
        },
      );
    });
  }
}
