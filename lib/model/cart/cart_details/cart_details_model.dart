// To parse this JSON data, do
//
//     final cartDetailModel = cartDetailModelFromJson(jsonString);

import 'dart:convert';

CartDetailModel cartDetailModelFromJson(String str) =>
    CartDetailModel.fromJson(json.decode(str));

String cartDetailModelToJson(CartDetailModel data) =>
    json.encode(data.toJson());

class CartDetailModel {
  CartDetailModel({
    required this.totalItem,
    required this.totalPrice,
    required this.deliveryCharges,
    required this.applyCopunCode,
    required this.couponDiscount,
    required this.couponCode,
    required this.totalBill,
  });

  int totalItem;
  int totalPrice;
  int deliveryCharges;
  bool applyCopunCode;
  int couponDiscount;
  String? couponCode;
  int totalBill;

  factory CartDetailModel.fromJson(Map<String, dynamic> json) =>
      CartDetailModel(
        totalItem: json["totalItem"],
        totalPrice: json["totalPrice"],
        deliveryCharges: json["deliveryCharges"],
        applyCopunCode: json["applyCopunCode"],
        couponDiscount: json["couponDiscount"],
        couponCode: json["couponCode"],
        totalBill: json["totalBill"],
      );

  Map<String, dynamic> toJson() => {
        "totalItem": totalItem,
        "totalPrice": totalPrice,
        "deliveryCharges": deliveryCharges,
        "applyCopunCode": applyCopunCode,
        "couponDiscount": couponDiscount,
        "couponCode": couponCode,
        "totalBill": totalBill,
      };
}
