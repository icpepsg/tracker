// To parse this JSON data, do
//
//     final trackerModel = trackerModelFromJson(jsonString);

import 'dart:convert';

ApiModel apiModelFromJson(String str) => ApiModel.fromJson(json.decode(str));

String apiModelToJson(ApiModel data) => json.encode(data.toJson());

class ApiModel {
  ApiModel({
    this.success,
    this.message,
  });

  bool success;
  String message;

  factory ApiModel.fromJson(Map<String, dynamic> json) => ApiModel(
    success: json["success"],
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message
  };
}


