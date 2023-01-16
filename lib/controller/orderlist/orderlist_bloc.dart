import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/model/orderlist/orderlist_model.dart';
import 'package:eat_incredible_app/repo/cart_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'orderlist_event.dart';
part 'orderlist_state.dart';
part 'orderlist_bloc.freezed.dart';

class OrderlistBloc extends Bloc<OrderlistEvent, OrderlistState> {
  OrderlistBloc() : super(const _Initial()) {
    on<_OrderList>((event, emit) async {
      emit(const _Loading());
      List<OrderModel> orderList = [];
      var result = await CartRepo().orderList();
      result.when(
        success: (data) {
          Logger().e(data);
          for (var i in data) {
            orderList.add(OrderModel.fromJson(i));
          }
          emit(_Loaded(orderList));
        },
        failure: (msg) {
          emit(_Failure(NetworkExceptions.getErrorMessage(msg)));
        },
      );
    });
  }
}
