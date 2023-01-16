// To parse this JSON data, do
//
//     final couponModel = couponModelFromJson(jsonString);

import 'dart:convert';

CouponModel couponModelFromJson(String str) =>
    CouponModel.fromJson(json.decode(str));

String couponModelToJson(CouponModel data) => json.encode(data.toJson());

class CouponModel {
  CouponModel({
    required this.id,
    required this.couponImage,
    required this.couponCode,
    required this.couponPercentage,
    required this.maxPrice,
    required this.startsAt,
    required this.expiresAt,
    required this.maxUsesUser,
    required this.status,
    required this.couponImg,
  });

  String id;
  dynamic couponImage;
  String couponCode;
  String couponPercentage;
  String maxPrice;
  String startsAt;
  String expiresAt;
  String maxUsesUser;
  String status;
  String couponImg;

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        id: json["id"],
        couponImage: json["coupon_image"],
        couponCode: json["coupon_code"],
        couponPercentage: json["coupon_percentage"],
        maxPrice: json["max_price"],
        startsAt: json["starts_at"],
        expiresAt: json["expires_at"],
        maxUsesUser: json["max_uses_user"],
        status: json["status"],
        couponImg: json["coupon_img"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "coupon_image": couponImage,
        "coupon_code": couponCode,
        "coupon_percentage": couponPercentage,
        "max_price": maxPrice,
        "starts_at": startsAt,
        "expires_at": expiresAt,
        "max_uses_user": maxUsesUser,
        "status": status,
        "coupon_img": couponImg,
      };
}
