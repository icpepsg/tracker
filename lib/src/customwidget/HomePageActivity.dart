import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  GoogleMapController _controller;

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
          strokeColor: Colors.green,
          center: latlng,
          fillColor: Colors.green.withAlpha(70));
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
        child:  Container(
           child: Column(
            children: <Widget>[
             Container(
                 child: Column(
                     children: <Widget>[
                       Container(
                         alignment: Alignment.center,
                         height: 100,
                       ),
                             SizedBox(
                                 width: MediaQuery.of(context).size.width,  // or use fixed size like 200
                                 height: 300,
                                 child:
                                 GoogleMap(
                                   mapType: MapType.hybrid,
                                   initialCameraPosition: initialLocation,
                                   markers: Set.of((marker != null) ? [marker] : []),
                                   circles: Set.of((circle != null) ? [circle] : []),
                                   onMapCreated: (GoogleMapController controller) {
                                     _controller = controller;
                                   },
                                 )
                             )
                             ,

                             Text( "\n\nLATITUDE: ${latlng.latitude} \n LONGITUDE:  ${latlng.longitude}"),

                     ]
                 )
             ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Container(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(color: Colors.green[600])),
                  onPressed: () {
                    setState(() {
                      submit = 1;
                    });
                    if(submit ==1){
                      getCurrentLocation();
                    }
                  },
                  color: Colors.green[600],
                  textColor: Colors.white,
                  child: Text("Start Activity".toUpperCase(),
                      style: TextStyle(fontSize: 15)),
                ),
              ),

              Expanded(
                flex: 1,
                child: SizedBox(),
              ),

            ],
           ),
        ),
    );
  }

}