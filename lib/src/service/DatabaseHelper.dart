import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';
import 'package:tracker/src/model/location_model.dart';
import 'package:path/path.dart' as p;
class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;
  DatabaseHelper._createInstance();

  static const String TABLE_LOCATION = "location";
  static const String COLUMN_ID = "id";
  static const String COLUMN_ACTIVIY_ID = "activityId";
  static const String COLUMN_DEVICEID = "deviceId";
  static const String COLUMN_LATITUDE = "latitude";
  static const String COLUMN_LONGITUDE = "longitude";
  static const String COLUMN_TIMESTAMP = "timestamp";
  static const String COLUMN_UPLOADED = "uploaded";


  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }
  Future<Database> get database async {
    if (_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }
  Future<Database> initializeDatabase() async {
    print('initializeDatabase() : ');
    Directory directory = await getApplicationDocumentsDirectory();
    String path = p.join(directory.path , 'location.db') ;
    var locDb = await openDatabase(path,version: 2,onCreate: _createDB,onUpgrade: _onUpgrade);
    return locDb;
  }
  void _createDB(Database db, int version) async {
    print('_createDB() : ' +version.toString());
    await db.execute('CREATE TABLE $TABLE_LOCATION($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_ACTIVIY_ID INTEGER , $COLUMN_DEVICEID TEXT '
                    ',$COLUMN_LATITUDE TEXT,$COLUMN_LONGITUDE TEXT, $COLUMN_TIMESTAMP TEXT )');
  }
  void _onUpgrade(Database db, int oldVersion, int newVersion) async{
    print('_onUpgrade() : ' + oldVersion.toString() +' : ' +newVersion.toString() );
    await db.execute('alter table $TABLE_LOCATION rename to tmp');
    await db.execute('CREATE TABLE $TABLE_LOCATION($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_ACTIVIY_ID INTEGER , $COLUMN_DEVICEID TEXT '
        ',$COLUMN_LATITUDE TEXT,$COLUMN_LONGITUDE TEXT, $COLUMN_TIMESTAMP TEXT , $COLUMN_UPLOADED TEXT )');
    await db.execute('insert into $TABLE_LOCATION select T1.*,\'\' from tmp as T1 ');
    await db.execute('DROP TABLE tmp ');
    print('_onUpgrade() : end ');
  }
  
  Future<List<Map<String,dynamic>>>getLocationList() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT DISTINCT $COLUMN_ACTIVIY_ID FROM $TABLE_LOCATION');
    return result;
  }

  Future<int> insert(LocationModel loc) async{
    Database db = await this.database;
    print(loc.activityId);
    print(loc.deviceId);
    var result = await db.insert(TABLE_LOCATION, loc.toMap());
    return result;
    
}
  Future<int> deleteRecord(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $TABLE_LOCATION WHERE $COLUMN_ID = $id');
    return result;
  }
  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $TABLE_LOCATION');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
  Future<List<LocationModel>> getRecordList() async {

    var mapList = await getLocationList(); // Get 'Map List' from database
    int count = mapList.length;         // Count the number of map entries in db table
    print('getRecordList' + mapList.toString() +' count = ' +count.toString());
    List<LocationModel> list = List<LocationModel>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      list.add(LocationModel.fromMap(mapList[i]));
    }
    return list;
  }
  Future<int> updateRecord(LocationModel location) async {
    var db = await this.database;
    var result = await db.update(TABLE_LOCATION, location.toMap(), where: '$COLUMN_ID = ?', whereArgs: [location.id]);
    print(result);
    return result;
  }
  Future<int> updateFlag(LocationModel location) async {
    var db = await this.database;
    var result = await db.rawUpdate('UPDATE $TABLE_LOCATION SET $COLUMN_UPLOADED = \'Y\' WHERE $COLUMN_ID = ? ',[location.id]);
    print('result : $location.id = ' +result.toString());
    return result;
  }
  Future<List<LocationModel>> getDetailList(String activityId) async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $TABLE_LOCATION WHERE $COLUMN_ACTIVIY_ID = $activityId');
    print(result);
    int count = result.length;         // Count the number of map entries in db table

    List<LocationModel> list = List<LocationModel>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      list.add(LocationModel.fromMap(result[i]));
    }
    return list;
  }

  Future<String> getMaxId(bool incrermentFlag) async {
    int ctr = 0;
    LocationModel locModel = LocationModel();
    Database db = await this.database;
    var result = await db.rawQuery('SELECT MAX($COLUMN_ACTIVIY_ID) AS $COLUMN_ACTIVIY_ID FROM $TABLE_LOCATION');
    print('MAX(sCOLUMN_ACTIVIY_ID) ==> '+result.toString());
    int count = result.length;         // Count the number of map entries in db table
    print('count ==> '+count.toString());
    List<LocationModel> list = List<LocationModel>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      locModel=LocationModel.fromMap(result[i]);
      if(locModel.activityId == null){
        print('getMaxId() : activityId is null' +locModel.toString());
      }else{
        print('getMaxId() : activityId = '+locModel.activityId.toString());
      }
      list.add(locModel);
    }
    if(list[0].activityId == null){
      print('activityId = > null' + ' change to zero');
    }else {
      print('activityId = > ' + list[0].activityId.toString());
      ctr = int.parse(list[0].activityId.toString());
      if(incrermentFlag){
        ctr++;
      } //else ctr will not increment
    }
    print('ctr==>> ' +ctr.toString());
    return ctr.toString();
  }

  Future<List<LocationModel>> getPending() async {

    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $TABLE_LOCATION  WHERE $COLUMN_UPLOADED = \'\'  OR $COLUMN_UPLOADED IS NULL');
   // print(result);
    int count = result.length;         // Count the number of map entries in db table
    List<LocationModel> list = List<LocationModel>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      //print('result[i]' +result[i].toString()); //for debugging
      list.add(LocationModel.fromMap(result[i]));
    }
    return list;
  }

}