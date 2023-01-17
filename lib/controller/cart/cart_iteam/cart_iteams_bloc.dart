import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/model/cart/cart_iteam/cart_iteam_model.dart';
import 'package:eat_incredible_app/repo/cart_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_iteams_event.dart';
part 'cart_iteams_state.dart';
part 'cart_iteams_bloc.freezed.dart';

class CartIteamsBloc extends Bloc<CartIteamsEvent, CartIteamsState> {
  CartIteamsBloc() : super(const _Initial()) {
    on<_GetCartIteams>((event, emit) async {
      List<CartIteamModel> cartIteamDataList = [];
      emit(const _Loading());
      var result = await CartRepo.getCartIteam();
      result.when(
        success: (data) {
          for (var element in data) {
            cartIteamDataList.add(CartIteamModel.fromJson(element));
          }
          emit(_Loaded(cartIteamList: cartIteamDataList));
        },
        failure: (error) {
          emit(_Error(message: NetworkExceptions.getErrorMessage(error)));
        },
      );
    });
  }
}
