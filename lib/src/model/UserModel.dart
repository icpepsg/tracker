// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.username,
    this.password,
    this.message,
    this.success,
    this.token,
    // ignore: non_constant_identifier_names
    this.device_id

  });

  String username;
  String password;
  String message;
  bool success;
  String token;
  // ignore: non_constant_identifier_names
  String device_id;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    username: json["username"],
    password: json["password"],
    message: json["message"],
    success: json["success"],
    token: json["token"],
    device_id: json["device_id"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "message": message,
    "success": success,
    "token": token,
    "device_id": device_id,
  };
}
