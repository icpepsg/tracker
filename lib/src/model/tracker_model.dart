// To parse this JSON data, do
//
//     final trackerModel = trackerModelFromJson(jsonString);

import 'dart:convert';

TrackerModel trackerModelFromJson(String str) => TrackerModel.fromJson(json.decode(str));

String trackerModelToJson(TrackerModel data) => json.encode(data.toJson());

class TrackerModel {
  TrackerModel({
    this.deviceId,
    this.datalist,
  });

  String deviceId;
  Datalist datalist;

  factory TrackerModel.fromJson(Map<String, dynamic> json) => TrackerModel(
    deviceId: json["device_id"],
    datalist: Datalist.fromJson(json["datalist"]),
  );

  Map<String, dynamic> toJson() => {
    "device_id": deviceId,
    "datalist": datalist.toJson(),
  };
}

class Datalist {
  Datalist({
    this.activityId,
    this.longitude,
    this.latitude,
    this.createdatetime,
  });

  int activityId;
  String longitude;
  String latitude;
  DateTime createdatetime;

  factory Datalist.fromJson(Map<String, dynamic> json) => Datalist(
    activityId: json["activity_id"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    createdatetime: json["createdatetime"],
  );

  Map<String, dynamic> toJson() => {
    "activity_id": activityId,
    "longitude": longitude,
    "latitude": latitude,
    "createdatetime": createdatetime,
  };
}
