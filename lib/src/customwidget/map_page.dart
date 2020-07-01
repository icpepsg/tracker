import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tracker/src/common/Constants.dart';
import 'package:tracker/src/model/location_model.dart';
import 'package:tracker/src/service/DatabaseHelper.dart';

import 'package:tracker/src/service/device_id.dart';
import 'package:tracker/src/service/marker_service.dart';
import 'package:screen/screen.dart';

class MapPage extends StatefulWidget {

  const MapPage({Key key}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

LatLng newPosition;
Set<Marker> markers = {};
int _index = 0;
int indexMarker;
ValueNotifier valueNotifier = ValueNotifier(indexMarker);

class _MapPageState extends State<MapPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isTrackingActive = false;
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  LatLng latlng = new LatLng(0, 0);
  double loclat;
  double loclong;
  DateTime now = new DateTime.now();
  GoogleMapController locationController;
  String dropdownValue = 'RUN/WALK';
  //Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  CameraPosition newCameraPosition =
  CameraPosition(target: LatLng(14.259504, 121.133800), zoom: 16);
  LocationModel locationModel = new  LocationModel();
  String deviceId;
  DatabaseHelper helper = DatabaseHelper();
  String maxId ;
  bool incrementFlag;
  @override
  void initState() {
    _getIsTrackingActive();
    getCurrentLocation();
    super.initState();
    getMarkers();
  }
  Future<String> getDid() async{
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('deviceId');
  }

  Future<bool> _getIsTrackingActive() async {
    final SharedPreferences prefs = await _prefs;
    deviceId = prefs.getString('deviceId');
    //initialize state here
    setState(() {
      (prefs.getBool('isTrackingActive')!=null) ? isTrackingActive =prefs.getBool('isTrackingActive') : isTrackingActive = false;
    });
    return isTrackingActive;
  }

  Future<void> _setIsTrackingActive(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("isTrackingActive", value);
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load(Constants.IMG_ARROW);
    return byteData.buffer.asUint8List();
  }
  void updateMarkerAndCircle( LocationData newLocalData, Uint8List imageData) {
    //newLocalData.latitude -> Current Latitude
    //newLocalData.longitude -> Current Longitude

    latlng = LatLng(newLocalData.latitude, newLocalData.longitude);

    this.setState(() {
      markers.add(
          Marker(
              markerId: MarkerId("home"),
              position: latlng,
              rotation: newLocalData.heading,
              draggable: false,
              zIndex: 2,
              flat: true,
              anchor: Offset(0.5, 0.5),
              icon: BitmapDescriptor.fromBytes(imageData))
            );
      //flat --> icon will be stick into the map
      circle = Circle(
          circleId: CircleId("direction"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.green,
          center: latlng,
          fillColor: Colors.green.withAlpha(70));
    });
  }




  //******* getMarkers */
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }



  void getMarkers() async {
    final Uint8List userMarkerIcon =
    await getBytesFromAsset('assets/images/normal_marker.png', 75);

    final Uint8List selectedMarkerIcon =
    await getBytesFromAsset('assets/images/selected_marker.png', 100);
    markers = {};

    MarkerService.markersList.forEach((element) {
      if (element.latitude != null && element.longitude != null) {
        if (element.id == indexMarker) {
          markers.add(Marker(
              draggable: false,
              markerId: MarkerId(element.latitude + element.longitude),
              position: LatLng(
                double.tryParse(element.latitude),
                double.tryParse(element.longitude),
              ),
              icon: BitmapDescriptor.fromBytes(selectedMarkerIcon),
              infoWindow: InfoWindow(title: element.name)));
        } else {
          markers.add(Marker(
              draggable: false,
              markerId: MarkerId(element.latitude + element.longitude),
              position: LatLng(
                double.tryParse(element.latitude),
                double.tryParse(element.longitude),
              ),
              icon: BitmapDescriptor.fromBytes(userMarkerIcon),
              infoWindow: InfoWindow(title: element.name)));
        }
      }
    });

    valueNotifier.value = indexMarker;
  }
  Future<String> getMax() async{
    var aId = await  helper.getMaxId(incrementFlag);
    return aId;
  }

  void insertLocation(String a,String b) async{
    getMax().then((valueA){
      locationModel.activityId = valueA ;
      print('locationModel.activityId = > ' +valueA.toString());
      getDid().then((valueB){
        locationModel.deviceId = valueB ;
        print('locationModel.deviceId = > ' +valueB.toString());
        locationModel.latitude  = a ;
        locationModel.longitude = b ;
        locationModel.timestamp = DateTime.now().toString();
        insert().then((valueC){
          print('result.int = > ' +valueC.toString());
        });
      });
    });

  }
  Future<int> insert() async{
    int result;
    if (locationModel.id != null) {
      result = await helper.updateRecord(locationModel);
    } else {
      result = await helper.insert(locationModel);
    }
    return result;
  }

  void getCurrentLocation() async {
    try {

      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);
      print('getCurrentLocation' +location.longitude.toString());
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      _locationSubscription = _locationTracker.onLocationChanged().listen((newLocalData) {
        if (mapController != null) {
          mapController.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 0,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 17.00)));
          updateMarkerAndCircle(newLocalData, imageData);
          if(isTrackingActive){
            insertLocation(latlng.latitude.toString(),latlng.longitude.toString());
            incrementFlag=false;
           // print('LATITUDE: ${latlng.latitude}  LONGITUDE:  ${latlng.longitude}' +' Timestamp : ' +DateTime.now().toString());
              //tryThis(latlng.latitude.toString(),latlng.longitude.toString(),DateTime.now().toString());
              print('Device : $deviceId  LATITUDE: ${latlng.latitude}  LONGITUDE:  ${latlng.longitude}' +' Timestamp : ' +DateTime.now().toString());
          }
        }
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }
  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        initialData: 0,
        builder: (context, snapshot) {
          return Scaffold(
              body: Container(
                  child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Column(
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,  // or use fixed size like 200
                                    height: MediaQuery.of(context).size.height*.8,
                                    child: ValueListenableBuilder(
                                        valueListenable: valueNotifier, // that's the value we are listening to
                                        builder: (context, value, child) {
                                          return  (latlng.latitude!=null && latlng.latitude != 0.0) ? GoogleMap(
                                            mapType: MapType.normal,
                                            initialCameraPosition: newCameraPosition,
                                            myLocationEnabled: true,
                                            zoomGesturesEnabled: true,
                                            markers: markers,
                                            //markers: Set.of((marker != null) ? [marker] : []),
                                            circles: Set.of((circle != null) ? [circle] : []),
                                            onMapCreated: (GoogleMapController controller) {
                                              mapController = controller;
                                              print('latlng.latitude ' +latlng.latitude.toString());
                                              print('latlng.longitude ' +latlng.longitude.toString());
                                              mapController.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
                                                  bearing: 0,
                                                  target: LatLng(latlng.latitude, latlng.longitude),
                                                  tilt: 0,
                                                  zoom: 17.00))).then((val) {setState(() {});});

                                            },
                                          )
                                          : Scaffold(body:Center(child: CircularProgressIndicator(),))
                                          ;
                                        }),
                                  ),
                                  //Text( "\n\nLATITUDE: ${latlng.latitude} \n LONGITUDE:  ${latlng.longitude}"),
                                ]
                            ),
                            Positioned(
                                bottom: MediaQuery.of(context).size.height*.1,
                                child: Center(
                                  // child: Text( "\n\nLATITUDE: ${latlng.latitude} \n LONGITUDE:  ${latlng.longitude}" ,style: TextStyle(color: Colors.green[600])),
                                )
                            ),

                            Positioned(
                              bottom: MediaQuery.of(context).size.height*.02,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FutureBuilder(
                                    future: _getIsTrackingActive(),
                                    builder: (context,snapshot){
                                      return (isTrackingActive!=null) ?
                                      (isTrackingActive) ?
                                        OutlineButton(
                                        onPressed: () {
                                          print('isTrackingActive=> $isTrackingActive');
                                          setState(() {
                                            isTrackingActive=false;
                                            Screen.keepOn(false);
                                            _setIsTrackingActive(isTrackingActive);
                                          });
                                        },
                                        borderSide: BorderSide(color: Colors.pink[100],width: 3),
                                        shape: StadiumBorder(),
                                        child: Text("End Activity",style: new TextStyle(color: Colors.pink[300],fontSize: 20,fontWeight: FontWeight.bold),
                                        ),
                                      )
                                      : OutlineButton(
                                        onPressed: () {
                                          setState((){
                                            incrementFlag=true;
                                            isTrackingActive=true;
                                            Screen.keepOn(true);
                                            _setIsTrackingActive(isTrackingActive);
                                          });
                                          print('isTrackingActive=> $isTrackingActive');
                                        },
                                        borderSide: BorderSide(color: Colors.green[300],width: 3),
                                        shape: StadiumBorder(),
                                        child: Text("Start Activity",style: new TextStyle(color: Colors.green[300],fontSize: 20,fontWeight: FontWeight.bold),
                                        ),
                                      )
                                      : CircularProgressIndicator();
                                    },
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height*.05,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  OutlineButton.icon(
                                    onPressed: (){},
                                    label: Text(dropdownValue,style: new TextStyle(color: Colors.pink[300],fontSize: 20)),
                                    icon: Icon(Icons.arrow_drop_down),
                                    shape: StadiumBorder(),
                                    borderSide: BorderSide(color: Colors.pink[100],width: 3),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                                bottom: MediaQuery.of(context).size.height*.01,
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 78.0),
                                    child: SizedBox(
                                      height: 116, // card height
                                      child: PageView.builder(
                                          itemCount: MarkerService.markersList.length, // how many items do we have
                                          controller: PageController(viewportFraction: 0.7),
                                          onPageChanged: (int index) {
                                            setState(() => _index = index);
                                            print('Index = > ' +index.toString());
                                            indexMarker = MarkerService.markersList[index].id;
                                            print('indexMarker : ' +indexMarker.toString());
                                            if (MarkerService.markersList[index].latitude != null &&
                                                MarkerService.markersList[index].longitude != null) {
                                              print('MarkerService.markersList[index].latitude : ' +MarkerService.markersList[index].latitude);
                                              newPosition = LatLng(double.tryParse(MarkerService.markersList[index].latitude),
                                                  double.tryParse(MarkerService.markersList[index].longitude));
                                              newCameraPosition =  CameraPosition(target: newPosition, zoom: 14,);
                                              print(newCameraPosition);
                                              mapController.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
                                                  bearing: 0,
                                                  target: LatLng(double.tryParse(MarkerService.markersList[index].latitude),
                                                      double.tryParse(MarkerService.markersList[index].longitude)),
                                                  tilt: 0,
                                                  zoom: 16.00)));
                                            }
                                            getMarkers();
                                            // locationController.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition)).then((value) => null);
                                            //mapController.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition)).then((val) {setState(() {});});
                                          },
                                          itemBuilder: (_, i) {
                                            return Transform.scale(
                                                scale: i == _index ? 1 : 0.7,
                                                child: new Container(
                                                    height: 100.00,
                                                    width: 250.00,
                                                    decoration: BoxDecoration(
                                                      color: Color(0xffffffff),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          offset: Offset(0.2, 0.2),
                                                          color:
                                                          Color(0xff000000).withOpacity(0.12),
                                                          blurRadius: 20,
                                                        ),
                                                      ],
                                                      borderRadius: BorderRadius.circular(10.00),
                                                    ),
                                                    child: Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: const EdgeInsets.only(left: 9, top: 7, bottom: 7, right: 9),
//put the image here
                                                            /*
                                              child: Container(
                                                height: 86.00,
                                                width: 86.00,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(Constants.API_URL_DEFAULT_PHOTO),
                                                  ),
                                                  borderRadius: BorderRadius.circular(5.00),
                                                ),
                                              ),
//
                                            */
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(
                                                                top: 12, right: 0.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              mainAxisSize: MainAxisSize.max,
                                                              children: <Widget>[
                                                                Wrap(
                                                                  alignment: WrapAlignment.start,
                                                                  spacing: 4,
                                                                  direction: Axis.vertical,
                                                                  children: <Widget>[
                                                                    Text(MarkerService.markersList[i].name,
                                                                      style: TextStyle(
                                                                        fontFamily: "Montserrat",
                                                                        fontSize: 20,
                                                                        color: Color(0xff000000),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: 230,
                                                                      child: Text(
                                                                        MarkerService.markersList[i].description,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        maxLines: 3,
                                                                        style: TextStyle(
                                                                          fontFamily: "Montserrat",
                                                                          fontSize: 15,
                                                                          color: Color(0xff000000),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ]
                                                    )
                                                )
                                            );
                                          }
                                      ),
                                    )
                                )
                            )
                          ],
                        ),
                      ]
                  )
              )
          );
        }
    );
  }

//***************************************************************

  //***********************************************************************

}


