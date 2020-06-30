

import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

class DeviceId {
  String deviceID, hardware, brand, id, identifierForVendor;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  Future<String> getDeviceId() async{
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
          return androidDeviceInfo.androidId.toString();
      } else if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
          print('identifierForVendor: ${iosDeviceInfo.identifierForVendor}');
          return iosDeviceInfo.identifierForVendor.toString();
      }
    } on PlatformException {
      print('Error: Failed to get platform version.');
    }
  }



}