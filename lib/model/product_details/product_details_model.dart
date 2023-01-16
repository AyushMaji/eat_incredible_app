// To parse this JSON data, do
//
//     final productDeatilsModel = productDeatilsModelFromJson(jsonString);

import 'dart:convert';

ProductDeatilsModel productDeatilsModelFromJson(String str) =>
    ProductDeatilsModel.fromJson(json.decode(str));

String productDeatilsModelToJson(ProductDeatilsModel data) =>
    json.encode(data.toJson());

class ProductDeatilsModel {
  ProductDeatilsModel({
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
    required this.variantId,
    required this.iscart,
    required this.shareLink,
    required this.productMoreImg,
  });

  String id;
  String productName;
  String slug;
  String categoryId;
  String tax;
  String originalPrice;
  String salePrice;
  String weight;
  String nutriBenifit;
  String description;
  String metaTitle;
  String metaTag;
  String metaDesc;
  String thumbnail;
  String thumbHover;
  String quantity;
  String status;
  String date;
  String variantId;
  bool iscart;
  String shareLink;
  List<String> productMoreImg;

  factory ProductDeatilsModel.fromJson(Map<String, dynamic> json) =>
      ProductDeatilsModel(
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
        variantId: json["variant_id"],
        iscart: json["iscart"],
        shareLink: json["share_link"],
        productMoreImg:
            List<String>.from(json["product_more_img"].map((x) => x)),
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
        "variant_id": variantId,
        "iscart": iscart,
        "share_link": shareLink,
        "product_more_img": List<dynamic>.from(productMoreImg.map((x) => x)),
      };
}
