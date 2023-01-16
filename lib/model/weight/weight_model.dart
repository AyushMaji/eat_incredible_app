// To parse this JSON data, do
//
//     final weightModel = weightModelFromJson(jsonString);

import 'dart:convert';

WeightModel weightModelFromJson(String str) =>
    WeightModel.fromJson(json.decode(str));

String weightModelToJson(WeightModel data) => json.encode(data.toJson());

class WeightModel {
  WeightModel({
    required this.id,
    required this.weight,
  });

  String id;
  String weight;

  factory WeightModel.fromJson(Map<String, dynamic> json) => WeightModel(
        id: json["id"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "weight": weight,
      };
}
