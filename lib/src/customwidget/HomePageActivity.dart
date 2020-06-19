import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:tracker/src/common/Constants.dart';

class HomePageActivity extends StatefulWidget {
  final Color color;

  const HomePageActivity({Key key, this.color}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<HomePageActivity> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  LatLng latlng = new LatLng(0, 0);
  double loclat;
  double loclong;
  DateTime now = new DateTime.now();
  GoogleMapController _controller;
  String dropdownValue = 'RUN/WALK';
  int _index;
  @override
  void initState() {
    super.initState();

    getCurrentLocation();
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(14.259504, 121.133800),
    zoom: 14.4746,
  );
  //default cameraposition

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load(Constants.IMG_ARROW);
    return byteData.buffer.asUint8List();
  }
  void updateMarkerAndCircle( LocationData newLocalData, Uint8List imageData) {
    //newLocalData.latitude -> Current Latitude
    //newLocalData.longitude -> Current Longitude
    latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    //print('LATITUDE: ${latlng.latitude} \n LONGITUDE:  ${latlng.longitude} ');

    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      //flat --> icon will be stick into the map
      circle = Circle(
          circleId: CircleId("direction"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.green[300],
          center: latlng,
          fillColor: Colors.green[100]);

      print('now => ' + DateTime.now().toString() +' => LATITUDE: ${latlng.latitude}   LONGITUDE:  ${latlng.longitude}');
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();
      updateMarkerAndCircle(location, imageData);
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      _locationSubscription = _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 19.00)));
          //18
          updateMarkerAndCircle(newLocalData, imageData);
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
    int submit = 0;

    return Container(
           child: Column(
            children: <Widget>[
             Stack(
                children: <Widget>[
                  Column(
                     children: <Widget>[
                             SizedBox(
                                 width: MediaQuery.of(context).size.width,  // or use fixed size like 200
                                 height: MediaQuery.of(context).size.height*.8,
                                 child:
                                 GoogleMap(
                                   mapType: MapType.normal,
                                   initialCameraPosition: initialLocation,
                                   markers: Set.of((marker != null) ? [marker] : []),
                                   circles: Set.of((circle != null) ? [circle] : []),
                                   onMapCreated: (GoogleMapController controller) {
                                     _controller = controller;
                                   },
                                 )
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
                    bottom: MediaQuery.of(context).size.height*.05,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new OutlineButton(
                          onPressed: () {
                          },
                          borderSide: BorderSide(color: Colors.pink[100],width: 3),
                          shape: StadiumBorder(),
                          //shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),

                          child: new Text(
                            "Start Activity",
                            style: new TextStyle(color: Colors.pink[300],fontSize: 20),
                          ),
                        ),
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
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 78.0),
                        child: SizedBox(
                               height: 116, // card height
                              child: PageView.builder(
                                itemCount: 3, // how many items do we have
                                controller: PageController(viewportFraction: 0.9),
                                onPageChanged: (int index) {
                                },
                                itemBuilder: (_, i) {
                                  return Transform.scale(
                                    scale: i == _index ? 1 : 0.9,
                                      child: new Container(
                                      height: 116.00,
                                      width: 325.00,
                                      decoration: BoxDecoration(
                                      color: Color(0xffffffff),
                                      boxShadow: [
                                        BoxShadow(
                                        offset: Offset(0.5, 0.5),
                                        color:
                                        Color(0xff000000).withOpacity(0.12),
                                        blurRadius: 20,
                                        ),
                                        ],
                                        borderRadius: BorderRadius.circular(10.00),
                                      ),
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
    );
  }



}
