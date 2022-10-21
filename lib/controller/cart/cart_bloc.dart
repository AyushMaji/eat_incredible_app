import 'dart:developer';

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
      emit(const _Loading());
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var result = await CartRepo.addToCart(event.productid);
      log(result.toString());
      if (result.data['guest'] !=null) {
        log("${result.data['guest']}guest");
        prefs.setString('guest_id', result.data['guest'].toString());
      }
    });
  }
}
