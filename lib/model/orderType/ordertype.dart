// To parse this JSON data, do
//
//     final orderTypeModel = orderTypeModelFromJson(jsonString);

import 'dart:convert';

OrderTypeModel orderTypeModelFromJson(String str) =>
    OrderTypeModel.fromJson(json.decode(str));

String orderTypeModelToJson(OrderTypeModel data) => json.encode(data.toJson());

class OrderTypeModel {
  OrderTypeModel({
    required this.orderNumber,
    required this.orderName,
    required this.orderEmail,
    required this.orderType,
    required this.status,
    required this.totalBill,
    required this.number,
  });

  String orderNumber;
  String orderName;
  String orderEmail;
  String orderType;
  int status;
  String totalBill;
  String number;

  factory OrderTypeModel.fromJson(Map<String, dynamic> json) => OrderTypeModel(
        orderNumber: json["order_number"],
        orderName: json["order_name"],
        orderEmail: json["order_email"],
        orderType: json["order_type"],
        status: json["status"],
        number: json["order_phone"],
        totalBill: json["total_bill"],
      );

  Map<String, dynamic> toJson() => {
        "order_number": orderNumber,
        "order_name": orderName,
        "order_email": orderEmail,
        "order_type": orderType,
        "status": status,
        "total_bill": totalBill,
        "order_phone": number,
      };
}
