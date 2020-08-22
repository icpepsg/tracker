// To parse this JSON data, do
//
//     final markersModel = markersModelFromJson(jsonString);

import 'dart:convert';

MarkersModel markersModelFromJson(String str) => MarkersModel.fromJson(json.decode(str));

String markersModelToJson(MarkersModel data) => json.encode(data.toJson());

class MarkersModel {
  MarkersModel({
    this.longitude,
    this.latitude,
    this.city,
    this.success,
    this.message,
    this.dteUpload,
  });
  double longitude;
  double latitude;
  List<City> city;
  bool success;
  String message;
  String dteUpload;

  factory MarkersModel.fromJson(Map<String, dynamic> json) => MarkersModel(
    longitude: json["longitude"],
    latitude: json["latitude"],
    city: List<City>.from(json["city"].map((x) => City.fromJson(x))),
    success: json["success"],
    message: json["message"],
    dteUpload: json["dteUpload"],
  );

  Map<String, dynamic> toJson() => {
    "longitude": longitude,
    "latitude": latitude,
    "city": List<dynamic>.from(city.map((x) => x.toJson())),
    "success": success,
    "message": message,
    "dteUpload": dteUpload,
  };
}

class City {
  City({
    this.name,
    this.lat,
    this.lng,
    this.info,
  });

  String name;
  String lat;
  String lng;
  List<Info> info;

  factory City.fromJson(Map<String, dynamic> json) => City(
    name: json["name"],
    lat: json["lat"],
    lng: json["lng"],
    info: List<Info>.from(json["info"].map((x) => Info.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "lat": lat,
    "lng": lng,
    "info": List<dynamic>.from(info.map((x) => x.toJson())),
  };
}

class Info {
  Info({
    this.active,
    this.recovered,
    this.died,
  });

  String active;
  String recovered;
  String died;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
    active: json["Active"] == null ? null : json["Active"],
    recovered: json["Recovered"] == null ? null : json["Recovered"],
    died: json["Died"] == null ? null : json["Died"],
  );

  Map<String, dynamic> toJson() => {
    "Active": active == null ? null : active,
    "Recovered": recovered == null ? null : recovered,
    "Died": died == null ? null : died,
  };
}
