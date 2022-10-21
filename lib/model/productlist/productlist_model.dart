// To parse this JSON data, do
//
//     final productlistModel = productlistModelFromJson(jsonString);

import 'dart:convert';

ProductlistModel productlistModelFromJson(String str) =>
    ProductlistModel.fromJson(json.decode(str));

String productlistModelToJson(ProductlistModel data) =>
    json.encode(data.toJson());

class ProductlistModel {
  ProductlistModel({
    required this.id,
    required this.productName,
    required this.slug,
    required this.categoryId,
    required this.tax,
    required this.originalPrice,
    required this.salePrice,
    required this.weight,
    required this.nutriBenifit,
    required this.description,
    required this.metaTitle,
    required this.metaTag,
    required this.metaDesc,
    required this.thumbnail,
    required this.thumbHover,
    required this.quantity,
    required this.status,
    required this.date,
    required this.topSellingProduct,
    required this.couponCode,
    required this.specialPrice,
    required this.locationId,
    required this.iscart,
    required this.discountPercentage,
  });

  String? id;
  String? productName;
  String? slug;
  String? categoryId;
  String? tax;
  String? originalPrice;
  String? salePrice;
  String? weight;
  String? nutriBenifit;
  String? description;
  String? metaTitle;
  String? metaTag;
  String? metaDesc;
  String? thumbnail;
  String? thumbHover;
  String? quantity;
  String? status;
  String? date;
  dynamic topSellingProduct;
  dynamic couponCode;
  dynamic specialPrice;
  dynamic locationId;
  bool? iscart;
  int? discountPercentage;

  factory ProductlistModel.fromJson(Map<String, dynamic> json) =>
      ProductlistModel(
        id: json["id"],
        productName: json["product_name"],
        slug: json["slug"],
        categoryId: json["category_id"],
        tax: json["tax"],
        originalPrice: json["original_price"],
        salePrice: json["sale_price"],
        weight: json["weight"],
        nutriBenifit: json["nutri_benifit"],
        description: json["description"],
        metaTitle: json["meta_title"],
        metaTag: json["meta_tag"],
        metaDesc: json["meta_desc"],
        thumbnail: json["thumbnail"],
        thumbHover: json["thumb_hover"],
        quantity: json["quantity"],
        status: json["status"],
        date: json["date"],
        topSellingProduct: json["top_selling_product"],
        couponCode: json["coupon_code"],
        specialPrice: json["special_price"],
        locationId: json["location_id"],
        iscart: json["iscart"],
        discountPercentage: json["discount_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "slug": slug,
        "category_id": categoryId,
        "tax": tax,
        "original_price": originalPrice,
        "sale_price": salePrice,
        "weight": weight,
        "nutri_benifit": nutriBenifit,
        "description": description,
        "meta_title": metaTitle,
        "meta_tag": metaTag,
        "meta_desc": metaDesc,
        "thumbnail": thumbnail,
        "thumb_hover": thumbHover,
        "quantity": quantity,
        "status": status,
        "date": date,
        "top_selling_product": topSellingProduct,
        "coupon_code": couponCode,
        "special_price": specialPrice,
        "location_id": locationId,
        "iscart": iscart,
        "discount_percentage": discountPercentage,
      };
}
