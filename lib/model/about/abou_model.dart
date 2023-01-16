// To parse this JSON data, do
//
//     final aboutModel = aboutModelFromJson(jsonString);

import 'dart:convert';

AboutModel aboutModelFromJson(String str) =>
    AboutModel.fromJson(json.decode(str));

String aboutModelToJson(AboutModel data) => json.encode(data.toJson());

class AboutModel {
  AboutModel({
    required this.banner1,
    required this.banner2,
    required this.banner3,
    required this.banner4,
    required this.banner5,
    required this.about,
    required this.ourMission,
    required this.ourVision,
    required this.whyChooseUs,
    required this.ourFounders,
  });

  String banner1;
  String banner2;
  String banner3;
  String banner4;
  String banner5;
  String about;
  String ourMission;
  String ourVision;
  String whyChooseUs;
  String ourFounders;

  factory AboutModel.fromJson(Map<String, dynamic> json) => AboutModel(
        banner1: json["banner1"],
        banner2: json["banner2"],
        banner3: json["banner3"],
        banner4: json["banner4"],
        banner5: json["banner5"],
        about: json["about"],
        ourMission: json["our_mission"],
        ourVision: json["our_vision"],
        whyChooseUs: json["why_choose_us"],
        ourFounders: json["our_founders"],
      );

  Map<String, dynamic> toJson() => {
        "banner1": banner1,
        "banner2": banner2,
        "banner3": banner3,
        "banner4": banner4,
        "banner5": banner5,
        "about": about,
        "our_mission": ourMission,
        "our_vision": ourVision,
        "why_choose_us": whyChooseUs,
        "our_founders": ourFounders,
      };
}
