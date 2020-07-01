import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracker/src/history.dart';
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


  @override
  Widget build(BuildContext context) {

    if (locationList == null) {
      locationList = List<LocationModel>();
      print('Displaying History for activity => ' +activityId.toString());
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('History Detail'),
      ),
      body: getHistoryListView(),

    );
  }
  ListView getHistoryListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text('Activity Log no. ' +this.locationList[position].activityId.toString(), style: titleStyle,),
            subtitle: Text(this.locationList[position].deviceId +'\n Lat: ' +this.locationList[position].latitude + ' Lng: ' +this.locationList[position].longitude +'\n ' +this.locationList[position].timestamp),
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
          this.locationList = list;
          this.count = list.length;
        });
      });
    });
  }
}