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

  });

  String username;
  String password;
  String message;
  String success;


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    username: json["username"],
    password: json["password"],
    message: json["message"],
    success: json["success"],

  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "message": message,
    "success": success,

  };
}
