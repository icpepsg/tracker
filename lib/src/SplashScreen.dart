import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/src/LoginPage.dart';
import 'package:tracker/src/customwidget/CircularLoadingAnimation.dart';
import 'package:tracker/src/model/marker_model.dart';
import 'package:tracker/src/model/markers_model.dart';
import 'package:tracker/src/service/marker_service.dart';
import 'package:geolocator/geolocator.dart';
import 'Home.dart';
import 'package:http/http.dart' as http;

import 'common/Constants.dart';
class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int index;
  MarkersModel markers =  new MarkersModel();
  Position position ;
  double lat,lng;


  @override
  void initState() {
    super.initState();
    initMarker();

    Timer(Duration(seconds: 6), () {
      printUser();
      print('Date now : ' +DateTime.now().toString());
    });
/*    MarkerService.markersList.add(MarkerModel(
        1,
        "Toa Payoh",
        "Confirmed: 200\nRecovered: 120\nDeaths:19",
        "1.3404",
        "103.8453",
        ""));
    MarkerService.markersList.add(MarkerModel(
        2,
        "Braddell (Shell)",
        "Confirmed: 100\nRecovered:  20\nDeaths:1",
        "1.3413",
        "103.8475",
        ""));
    MarkerService.markersList.add(MarkerModel(
        3,
        "Bishan",
        "Confirmed: 20\nRecovered: 10\nDeaths:2",
        "1.3489",
        "103.8486",
        "")); */
  }
  Future<String> _getUser() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('username');
  }
  void printUser(){
    _getUser().then((value) {
      print('username : $value');
      if(value!=null){
        Navigator.of(context).push(MaterialPageRoute (builder: (context) => Home()));
      }else{
        Navigator.of(context).push(MaterialPageRoute (builder: (context) => LoginPage()));
      }
    });
  }
  Future<Position> _getPosition() async {
    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }
  Future<double> _getLat() async {
    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position.latitude;
  }
  Future<double> _getLng() async {
    position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position.longitude;
  }
  void initMarker() {
    _getPosition().then((value){
      print('latitude=>' +value.latitude.toString());
      print('longitude=>' +value.longitude.toString());
    });
    getResp();
  }
  void getResp(){
    submitData().then((result) {
      index=1;
      String active,died,recovered,remarks;
      //print('result = > '+result.body);
      Map markerMap = jsonDecode(result.body);
      var data = MarkersModel.fromJson(markerMap);
      print('success : ' + data.success.toString());
      List<City> cityList = data.city;
      cityList.forEach((cityElement) {
        List<Info> infoList = cityElement.info;
        infoList.forEach((element) {
          if (element.active!=null) { active = element.active.toString(); }
          if (element.died!=null) { died=element.died.toString(); }
          if (element.recovered!=null) { recovered = element.recovered.toString(); }
        });
        remarks = "Active: $active\nRecovered: $recovered\nDeaths:$died";
        MarkerService.markersList.add(MarkerModel(
            index,cityElement.name.toString(),
            remarks,
            cityElement.lat.toString(),
            cityElement.lng.toString(),
            ""));
        index++;
      }
      );
    });

  }

  Future<http.Response> submitData() async {
    markers.longitude = await _getLng();
    markers.latitude = await _getLat();
    markers.city = new List<City>();
    final resp = await http.post(Constants.API_URL_MARKERS,
        headers: {"Content-Type": "application/json"},
        body: markersModelToJson(markers));
    //print(resp);

    return resp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Center(child: CircularLoadingAnimation())));
  } // end build

}
