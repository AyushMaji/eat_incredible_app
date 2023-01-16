part of 'coupon_bloc.dart';

@freezed
class CouponState with _$CouponState {
  const factory CouponState.initial() = _Initial;
  const factory CouponState.loading() = _Loading;
  const factory CouponState.success(List<CouponModel> couponList) = _Success;
  const factory CouponState.failure(String error) = _Failure;
}
