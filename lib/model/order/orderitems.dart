// To parse this JSON data, do
//
//     final orderItemsModel = orderItemsModelFromJson(jsonString);

import 'dart:convert';

OrderItemsModel orderItemsModelFromJson(String str) =>
    OrderItemsModel.fromJson(json.decode(str));

String orderItemsModelToJson(OrderItemsModel data) =>
    json.encode(data.toJson());

class OrderItemsModel {
  OrderItemsModel({
    required this.id,
    required this.oid,
    required this.pid,
    required this.vid,
    required this.qnty,
    required this.price,
    required this.productName,
    required this.totalPrice,
    required this.image,
    required this.weight,
  });

  String id;
  String oid;
  String pid;
  String vid;
  String qnty;
  String price;
  String productName;
  int totalPrice;
  String image;
  String? weight;

  factory OrderItemsModel.fromJson(Map<String, dynamic> json) =>
      OrderItemsModel(
        id: json["id"],
        oid: json["oid"],
        pid: json["pid"],
        vid: json["vid"],
        qnty: json["qnty"],
        price: json["price"],
        productName: json["product_name"],
        totalPrice: json["total_price"],
        image: json["image"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "oid": oid,
        "pid": pid,
        "vid": vid,
        "qnty": qnty,
        "price": price,
        "product_name": productName,
        "total_price": totalPrice,
        "image": image,
        "weight": weight,
      };
}
