import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tracker/src/history.dart';
import 'package:tracker/src/history_detail.dart';
import 'package:tracker/src/model/location_model.dart';
import 'package:tracker/src/service/DatabaseHelper.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<LocationModel> locationList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if (locationList == null) {
      locationList = List<LocationModel>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('History Summary'),
      ),
      body: getHistoryListView(),
 /*     floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          //navigateToDetail(LocationModel('','', '', '',''), 'Add History');
          navigateToDetail(LocationModel(), 'Add History');
        },
        tooltip: 'Add History',
        child: Icon(Icons.add),
      ),*/
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
            title: Text('Activity Log no. ' +this.locationList[position].activityId, style: titleStyle,),
            //subtitle: Text(this.locationList[position].deviceId),
            onTap: () {
              debugPrint("ListTile Tapped");
               //navigateToDetail(this.locationList[position],'Edit History');
              navigateToDetail2(position);
            },

          ),
        );
      },
    );
  }

  void _delete(BuildContext context, LocationModel location) async {
    int result = await databaseHelper.deleteRecord(location.id);
    if (result != 0) {
      _showSnackBar(context, 'History Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(LocationModel location, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return History(location, title);
    }));

    if (result == true) {
      updateListView();
    }
  }
  void navigateToDetail2(int index) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HistoryDetail(index);
    }));

    if (result == true) {
      updateListView();
    }
  }
  void updateListView() {
    print('updateListView');
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<LocationModel>> listFuture = databaseHelper.getRecordList();
      listFuture.then((list) {
        setState(() {
          this.locationList = list;
          this.count = list.length;
        });
      });
    });
  }
}