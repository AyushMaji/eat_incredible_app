import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/model/order/orderitems.dart';
import 'package:eat_incredible_app/repo/cart_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'orderitems_event.dart';
part 'orderitems_state.dart';
part 'orderitems_bloc.freezed.dart';

class OrderitemsBloc extends Bloc<OrderitemsEvent, OrderitemsState> {
  OrderitemsBloc() : super(const _Initial()) {
    on<_OrderItems>((event, emit) async {
      emit(const _Loading());
      List<OrderItemsModel> orderItemslist = [];
      var result = await CartRepo().orderItem(event.orderId);
      result.when(
        success: (orderItems) {
          for (var item in orderItems) {
            orderItemslist.add(OrderItemsModel.fromJson(item));
          }
          emit(_Success(orderItems: orderItemslist));
        },
        failure: (error) =>
            emit(_Failure(message: NetworkExceptions.getErrorMessage(error))),
      );
    });
  }
}
