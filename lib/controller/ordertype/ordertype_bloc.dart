import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/model/orderType/ordertype.dart';
import 'package:eat_incredible_app/repo/cart_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ordertype_event.dart';
part 'ordertype_state.dart';
part 'ordertype_bloc.freezed.dart';

class OrdertypeBloc extends Bloc<OrdertypeEvent, OrdertypeState> {
  OrdertypeBloc() : super(const _Initial()) {
    on<_GetOrdertype>((event, emit) async {
      emit(const _Loading());
      var res = await CartRepo().orderType(event.paymentType);
      res.when(success: (value) {
        emit(_Loaded(ordertype: OrderTypeModel.fromJson(value)));
      }, failure: (error) {
        emit(_Error(message: NetworkExceptions.getErrorMessage(error)));
      });
    });
  }
}
