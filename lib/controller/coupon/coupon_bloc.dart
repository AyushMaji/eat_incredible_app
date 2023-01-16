import 'package:bloc/bloc.dart';
import 'package:eat_incredible_app/api/network_exception.dart';
import 'package:eat_incredible_app/model/coupon/coupon.dart';
import 'package:eat_incredible_app/repo/cart_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coupon_event.dart';
part 'coupon_state.dart';
part 'coupon_bloc.freezed.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  CouponBloc() : super(const _Initial()) {
    on<_GetCouponList>((event, emit) async {
      emit(const _Loading());
      List<CouponModel> couponList = [];
      var result = await CartRepo.couponList();

      result.when(
        success: (data) {
          for (var i = 0; i < data.length; i++) {
            couponList.add(CouponModel.fromJson(data[i]));
          }
          return emit(_Success(couponList));
        },
        failure: (error) {
          emit(_Failure(NetworkExceptions.getErrorMessage(error)));
        },
      );
    });
  }
}
