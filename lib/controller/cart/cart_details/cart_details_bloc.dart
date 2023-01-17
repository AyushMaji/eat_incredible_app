import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/model/cart/cart_details/cart_details_model.dart';
import 'package:eat_incredible_app/repo/cart_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_details_event.dart';
part 'cart_details_state.dart';
part 'cart_details_bloc.freezed.dart';

class CartDetailsBloc extends Bloc<CartDetailsEvent, CartDetailsState> {
  CartDetailsBloc() : super(const _Initial()) {
    on<_GetCartDetails>((event, emit) async {
      emit(const _Loading());
      var result = await CartRepo.getCartDetails(event.coupon);
      log(result.toString());
      result.when(
        success: (data) {
          emit(_Loaded(cartDetailModel: CartDetailModel.fromJson(data)));
        },
        failure: (error) {
          emit(_Error(message: NetworkExceptions.getErrorMessage(error)));
          emit(const _Initial());
        },
      );
    });
  }
}
