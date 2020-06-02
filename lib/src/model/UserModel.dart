// To parse this JSON data, do
//
//     final signupModel = signupModelFromJson(jsonString);

import 'dart:convert';

UserModel signupModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String signupModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String username;
  String firstname;
  String lastname;
  String middlename;
  String password;
  String mobileno;
  String email;
  String success;
  String message;

  UserModel({
    this.username,
    this.firstname,
    this.lastname,
    this.middlename,
    this.password,
    this.mobileno,
    this.email,
    this.success,
    this.message
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    username: json["username"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    middlename: json["middlename"],
    password: json["password"],
    mobileno: json["mobileno"],
    email: json["email"],
    success: json['success'],
    message: json['message']
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "firstname": firstname,
    "lastname": lastname,
    "middlename": middlename,
    "password": password,
    "mobileno": mobileno,
    "email": email,
    "success": success,
    "message": message

  };
}
