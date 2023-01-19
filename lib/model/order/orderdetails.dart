// To parse this JSON data, do
//
//     final orderDetailsModel = orderDetailsModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsModel orderDetailsModelFromJson(String str) =>
    OrderDetailsModel.fromJson(json.decode(str));

String orderDetailsModelToJson(OrderDetailsModel data) =>
    json.encode(data.toJson());

class OrderDetailsModel {
  OrderDetailsModel({
    required this.id,
    required this.odrNumber,
    required this.totalItems,
    required this.placedOn,
    required this.orderStatus,
    required this.payment,
    required this.address,
    required this.itemTotal,
    required this.deliveryFee,
    required this.discount,
    required this.totalBill,
    required this.invoice,
    this.odrStatus,
  });

  String id;
  String odrNumber;
  int totalItems;
  String placedOn;
  String orderStatus;
  String payment;
  String address;
  String itemTotal;
  int deliveryFee;
  int discount;
  String totalBill;
  String? invoice;
  int? odrStatus;

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModel(
        id: json["id"],
        odrNumber: json["odr_number"],
        totalItems: json["total_items"],
        placedOn: json["placed_on"],
        orderStatus: json["order_status"],
        payment: json["payment"],
        address: json["address"],
        itemTotal: json["item_total"],
        deliveryFee: json["delivery_fee"],
        discount: json["discount"],
        totalBill: json["total_bill"],
        invoice: json["invoice"],
        odrStatus: json["odr_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "odr_number": odrNumber,
        "total_items": totalItems,
        "placed_on": placedOn,
        "order_status": orderStatus,
        "payment": payment,
        "address": address,
        "item_total": itemTotal,
        "delivery_fee": deliveryFee,
        "discount": discount,
        "total_bill": totalBill,
        "invoice": invoice,
        "odr_status": odrStatus,
      };
}
