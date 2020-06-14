// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.email,
    this.password,
    this.message,
    this.success,

  });

  String email;
  String password;
  String message;
  String success;


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json["email"],
    password: json["password"],
    message: json["message"],
    success: json["success"],

  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "message": message,
    "success": success,

  };
}
