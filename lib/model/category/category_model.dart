// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.status,
    required this.addedOn,
    required this.categoryImg,
  });

  String id;
  String name;
  String slug;
  String status;
  String addedOn;
  String categoryImg;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        status: json["status"],
        addedOn: json["addedOn"],
        categoryImg: json["category_img"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "status": status,
        "addedOn": addedOn,
        "category_img": categoryImg,
      };
}
