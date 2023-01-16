import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/model/order/orderdetails.dart';
import 'package:eat_incredible_app/repo/cart_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'orderdetails_event.dart';
part 'orderdetails_state.dart';
part 'orderdetails_bloc.freezed.dart';

class OrderdetailsBloc extends Bloc<OrderdetailsEvent, OrderdetailsState> {
  OrderdetailsBloc() : super(const _Initial()) {
    on<_OrderDetails>((event, emit) async {
      emit(const _Loading());
      List<OrderDetailsModel> orderItems = [];
      var result = await CartRepo().orderDetails(event.orderId);
      result.when(
        success: (orderDetails) {
          for (var item in orderDetails) {
            orderItems.add(OrderDetailsModel.fromJson(item));
          }
          emit(_Success(orderDetails: orderItems));
        },
        failure: (error) =>
            emit(_Failure(message: NetworkExceptions.getErrorMessage(error))),
      );
    });
  }
}
