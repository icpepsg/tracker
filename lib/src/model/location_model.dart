import 'package:tracker/src/service/DatabaseHelper.dart';

class LocationModel {
  int id;
  String deviceId;
  String activityId;
  String latitude;
  String longitude;
  String timestamp;
  LocationModel({
      this.activityId,
      this.deviceId,
      this.latitude,
      this.longitude,
      this.timestamp});
  LocationModel.withId({
    this.id,
    this.activityId,
    this.deviceId,
    this.latitude,
    this.longitude,
    this.timestamp});
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseHelper.COLUMN_ACTIVIY_ID: activityId,
      DatabaseHelper.COLUMN_DEVICEID: deviceId,
      DatabaseHelper.COLUMN_LATITUDE: latitude,
      DatabaseHelper.COLUMN_LONGITUDE: longitude,
      DatabaseHelper.COLUMN_TIMESTAMP: timestamp
    };

    if (id != null) {
      map[DatabaseHelper.COLUMN_ID] = id;
    }

    return map;
  }

  LocationModel.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseHelper.COLUMN_ID];
    activityId = map[DatabaseHelper.COLUMN_ACTIVIY_ID];
    deviceId   = map[DatabaseHelper.COLUMN_DEVICEID];
    latitude   = map[DatabaseHelper.COLUMN_LATITUDE];
    longitude  = map[DatabaseHelper.COLUMN_LONGITUDE];
    timestamp  = map[DatabaseHelper.COLUMN_TIMESTAMP];
  }
  String toString(){
    return '{ $this.id,$this.activityId,$this.deviceId,$this.latitude,$this.longitude,$this.timestamp }';
  }

}