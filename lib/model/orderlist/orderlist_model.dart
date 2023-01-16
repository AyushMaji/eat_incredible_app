// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  OrderModel({
    required this.id,
    required this.odrNumber,
    required this.totalAmount,
    required this.totalItems,
    required this.placedOn,
    required this.orderStatus,
  });

  String? id;
  String? odrNumber;
  String? totalAmount;
  int? totalItems;
  String? placedOn;
  String? orderStatus;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        odrNumber: json["odr_number"],
        totalAmount: json["total_amount"],
        totalItems: json["total_items"],
        placedOn: json["placed_on"],
        orderStatus: json["order_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "odr_number": odrNumber,
        "total_amount": totalAmount,
        "total_items": totalItems,
        "placed_on": placedOn,
        "order_status": orderStatus,
      };
}
