import 'package:tracker/src/common/Constants.dart';
import 'package:tracker/src/customwidget/map_page.dart';
import 'customwidget/ImageContainer.dart';
import 'package:flutter/material.dart';

import 'customwidget/Profile.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  bool isOk = false;
  String data;
  @override
  void initState() {
    print('initState : _HomeState ');
    super.initState();
  }

  final List<Widget> _children = [
    MapPage(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            children: [
              Container(
                height: 45,
                child: ImageContainer(assetLocation: Constants.IMG_ICPEP),
              ),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'ICpEP Singapore',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.green[600]),
                  )),
            ],
          ),
        ),
        body: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: 70, minHeight: 70, maxWidth: 1800, maxHeight: 1800),
            //child: Container(color: Colors.red, width: 10, height: 10)
            child: _children[_currentIndex]), // new

        //child: _children[_currentIndex]
        /*floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async{


        },
      ),*/
        bottomNavigationBar: BottomNavigationBar(
          currentIndex:
              _currentIndex, // this will be set when a new tab is tapped
          selectedItemColor: Colors.green[700],
          unselectedItemColor: Colors.black,
          iconSize: 20,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home', style: TextStyle(color: Colors.black)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: new Text('Profile', style: TextStyle(color: Colors.black)),
            )
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
