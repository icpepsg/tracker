// To parse this JSON data, do
//
//     final fbModel = fbModelFromJson(jsonString);

import 'dart:convert';

FbModel fbModelFromJson(String str) => FbModel.fromJson(json.decode(str));

String fbModelToJson(FbModel data) => json.encode(data.toJson());

class FbModel {
  FbModel({
    this.email,
    this.password,
    this.message,
    this.success,
    this.id,
    this.firstName,
    this.lastName,
    this.middleName,
    this.name,
    this.nameFormat,
    this.shortName,
    this.picture,
  });

  String email;
  String password;
  String message;
  String success;
  String id;
  String firstName;
  String lastName;
  String middleName;
  String name;
  String nameFormat;
  String shortName;
  Picture picture;

  factory FbModel.fromJson(Map<String, dynamic> json) => FbModel(
    email: json["email"],
    password: json["password"],
    message: json["message"],
    success: json["success"],
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    middleName: json["middle_name"],
    name: json["name"],
    nameFormat: json["name_format"],
    shortName: json["short_name"],
    picture: Picture.fromJson(json["picture"]),
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "message": message,
    "success": success,
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "middle_name": middleName,
    "name": name,
    "name_format": nameFormat,
    "short_name": shortName,
    "picture": picture.toJson(),
  };
}

class Picture {
  Picture({
    this.data,
  });

  Data data;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.height,
    this.isSilhouette,
    this.url,
    this.width,
  });

  int height;
  bool isSilhouette;
  String url;
  int width;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    height: json["height"],
    isSilhouette: json["is_silhouette"],
    url: json["url"],
    width: json["width"],
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "is_silhouette": isSilhouette,
    "url": url,
    "width": width,
  };
}
