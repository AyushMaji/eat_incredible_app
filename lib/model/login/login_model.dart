// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel(
      {required this.message, required this.status, required this.isNewUser});

  String message;
  int status;
  bool isNewUser;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
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
