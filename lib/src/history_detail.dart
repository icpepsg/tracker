import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sqflite/sqflite.dart';

import 'package:tracker/src/model/location_model.dart';
import 'package:tracker/src/service/DatabaseHelper.dart';


class HistoryDetail extends StatefulWidget {

  final int activityId;
  HistoryDetail(this.activityId);

  @override
  _HistoryDetailState createState() => _HistoryDetailState(this.activityId);
}

class _HistoryDetailState extends State<HistoryDetail> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<LocationModel> locationList;
  int count = 0;
  int activityId;
  _HistoryDetailState(this.activityId);
  CameraPosition cameraPosition;
  //CameraPosition(target: LatLng(14.259504, 121.133800), zoom: 16);
  final Set<Polyline> _polyline = {};
  List<LatLng> latlngSegment1 = List();
  GoogleMapController controller;
  @override
  Widget build(BuildContext context) {

    if (locationList == null) {
      locationList = List<LocationModel>();
      print('Displaying History for activity => ' +activityId.toString());
      updateListView();

    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('History Detail'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height*.4,
            child: (cameraPosition!=null) ? GoogleMap(
              //that needs a list<Polyline>
              polylines: _polyline,
              //markers: _markers,
              onMapCreated: _onMapCreated,
              initialCameraPosition: cameraPosition,
              mapType: MapType.normal,
            ) : CircularProgressIndicator()
            ),
            Flexible(child: getHistoryListView(),)
          ],
        ))
    );
  }
  ListView getHistoryListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      shrinkWrap: true,
      //scrollDirection: Axis.horizontal,
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        int index = locationList[position].activityId;
        index+=1; print('index =>  $index');
        String uploaded;
        if (this.locationList[position].uploaded != null || this.locationList[position].uploaded!= ''){
          uploaded = "Yes";
        }else{
          uploaded = "Pending";
        }

        return Card(
          color: Colors.white,
          elevation: 4.0,
          child: ListTile(
            title: Text('Activity Log no. ' + index.toString(), style: titleStyle,),
            subtitle: Text('Lat: ' +this.locationList[position].latitude + '\nLng: ' +this.locationList[position].longitude +'\nTime:' +this.locationList[position].timestamp +'\nUploaded: ' +uploaded),
          ),
        );
      },
    );
  }


  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<LocationModel>> listFuture = databaseHelper.getDetailList(this.activityId.toString());
      listFuture.then((list) {
        setState(() {
          this.cameraPosition = CameraPosition(target: LatLng(double.parse(list[0].latitude), double.parse(list[0].longitude)), zoom: 16);
          print('cameraPosition '+cameraPosition.toString());
          this.locationList = list;
          this.count = list.length;
          list.forEach((element) {
            latlngSegment1.add(LatLng(double.parse(element.latitude), double.parse(element.longitude)));
            print(latlngSegment1);
          });


        });
      });
    });
  }
  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
      _polyline.add(Polyline(
        polylineId: PolylineId('line1'),
        visible: true,
        //latlng is List<LatLng>
        points: latlngSegment1,
        width: 6,
        color: Colors.green,
      ));
    });
  }


}