// To parse this JSON data, do
//
//     final viewAddressListModel = viewAddressListModelFromJson(jsonString);

import 'dart:convert';

ViewAddressListModel viewAddressListModelFromJson(String str) =>
    ViewAddressListModel.fromJson(json.decode(str));

String viewAddressListModelToJson(ViewAddressListModel data) =>
    json.encode(data.toJson());

class ViewAddressListModel {
  ViewAddressListModel({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.password,
    required this.accessToken,
    required this.lastLoginTime,
    required this.ipAddr,
    required this.addedOn,
    required this.secretkey,
    required this.status,
    required this.isVerified,
    required this.otpToken,
    required this.mobileOtp,
    required this.userId,
    required this.phone,
    required this.city,
    required this.location,
    required this.pincode,
    required this.locality,
    required this.landmark,
    required this.altPhone,
    required this.address,
    required this.successStatus,
  });

  String? id;
  String? name;
  dynamic mobile;
  String? email;
  String? password;
  dynamic accessToken;
  dynamic lastLoginTime;
  dynamic ipAddr;
  String? addedOn;
  dynamic secretkey;
  String? status;
  String? isVerified;
  String? otpToken;
  String? mobileOtp;
  String? userId;
  String? phone;
  String? city;
  String? location;
  String? pincode;
  String? locality;
  String? landmark;
  String? altPhone;
  String? address;
  int? successStatus;

  factory ViewAddressListModel.fromJson(Map<String, dynamic> json) =>
      ViewAddressListModel(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
        password: json["password"],
        accessToken: json["access_token"],
        lastLoginTime: json["last_login_time"],
        ipAddr: json["ip_addr"],
        addedOn: json["addedOn"],
        secretkey: json["secretkey"],
        status: json["status"],
        isVerified: json["isVerified"],
        otpToken: json["otp_token"],
        mobileOtp: json["mobile_otp"],
        userId: json["user_id"],
        phone: json["phone"],
        city: json["city"],
        location: json["location"],
        pincode: json["pincode"],
        locality: json["locality"],
        landmark: json["landmark"],
        altPhone: json["alt_phone"],
        address: json["address"],
        successStatus: json["success status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "email": email,
        "password": password,
        "access_token": accessToken,
        "last_login_time": lastLoginTime,
        "ip_addr": ipAddr,
        "addedOn": addedOn,
        "secretkey": secretkey,
        "status": status,
        "isVerified": isVerified,
        "otp_token": otpToken,
        "mobile_otp": mobileOtp,
        "user_id": userId,
        "phone": phone,
        "city": city,
        "location": location,
        "pincode": pincode,
        "locality": locality,
        "landmark": landmark,
        "alt_phone": altPhone,
        "address": address,
        "success status": successStatus,
      };
}
