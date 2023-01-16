part of 'coupon_bloc.dart';

@freezed
class CouponEvent with _$CouponEvent {
  const factory CouponEvent.started() = _Started;
  const factory CouponEvent.getCouponList() = _GetCouponList;
}
