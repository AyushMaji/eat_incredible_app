// To parse this JSON data, do
//
//     final invoiceModel = invoiceModelFromJson(jsonString);

import 'dart:convert';

InvoiceModel invoiceModelFromJson(String str) =>
    InvoiceModel.fromJson(json.decode(str));

String invoiceModelToJson(InvoiceModel data) => json.encode(data.toJson());

class InvoiceModel {
  InvoiceModel({
    required this.orderNumber,
    required this.totalBill,
    required this.invoice,
    required this.status,
  });

  String orderNumber;
  String totalBill;
  String invoice;
  int status;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        orderNumber: json["order_number"],
        totalBill: json["total_bill"],
        invoice: json["invoice"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "order_number": orderNumber,
        "total_bill": totalBill,
        "invoice": invoice,
        "status": status,
      };
}
