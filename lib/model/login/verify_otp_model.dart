// To parse this JSON data, do
//
//     final verifyModel = verifyModelFromJson(jsonString);

import 'dart:convert';

VerifyModel verifyModelFromJson(String str) =>
    VerifyModel.fromJson(json.decode(str));

String verifyModelToJson(VerifyModel data) => json.encode(data.toJson());

class VerifyModel {
  VerifyModel({
    required this.message,
    required this.status,
    required this.isNewUser,
  });

  String message;
  int status;
  bool isNewUser;

  factory VerifyModel.fromJson(Map<String, dynamic> json) => VerifyModel(
        message: json["message"],
        status: json["status"],
        isNewUser: json["isNewUser"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "isNewUser": isNewUser,
      };
}
