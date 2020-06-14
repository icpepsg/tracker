import 'package:tracker/src/common/Constants.dart';

import 'customwidget/ImageContainer.dart';
import 'customwidget/HomePageActivity.dart';
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
    HomePageActivity(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding: const EdgeInsets.all(8.0), child: Text('ICpEP Singapore',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.green[600]),)
            ),
          ],
        ),
      ),
      body: _children[_currentIndex], // new
      /*floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: () async{


        },
      ),*/
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // this will be set when a new tab is tapped
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.green[700],
        iconSize: 20,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home',style: TextStyle(color: Colors.green[700])),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: new Text('Profile',style: TextStyle(color: Colors.green[700])),
          )
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

}
