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
    required this.totalTax,
    required this.totalPriceIncTax,
    required this.deliveryDays,
    required this.deliveryCharges,
    required this.applyCopunCode,
    required this.totalBill,
    required this.couponDiscount,
  });

  int? totalItem;
  int? totalPrice;
  int? totalTax;
  int? totalPriceIncTax;
  int? deliveryDays;
  int? deliveryCharges;
  int? applyCopunCode;
  int? totalBill;
  int? couponDiscount;

  factory CartDetailModel.fromJson(Map<String, dynamic> json) =>
      CartDetailModel(
        totalItem: json["totalItem"],
        totalPrice: json["totalPrice"],
        totalTax: json["totalTax"],
        totalPriceIncTax: json["totalPriceIncTax"],
        deliveryDays: json["deliveryDays"],
        deliveryCharges: json["deliveryCharges"],
        applyCopunCode: json["applyCopunCode"],
        totalBill: json["totalBill"],
        couponDiscount: json["couponDiscount"],
      );

  Map<String, dynamic> toJson() => {
        "totalItem": totalItem,
        "totalPrice": totalPrice,
        "totalTax": totalTax,
        "totalPriceIncTax": totalPriceIncTax,
        "deliveryDays": deliveryDays,
        "deliveryCharges": deliveryCharges,
        "applyCopunCode": applyCopunCode,
        "totalBill": totalBill,
        "couponDiscount": couponDiscount,
      };
}
