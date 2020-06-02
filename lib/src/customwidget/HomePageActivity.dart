import 'package:flutter/material.dart';

class HomePageActivity extends StatelessWidget {
  final Color color;

  const HomePageActivity({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {

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
                       Container(
                         alignment: Alignment.center,
                         color: Colors.blue[100],
                         width: 400,
                         height: 300,
                         child: Text('Display map and current locatiion here', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,color: Colors.black)),
                       )
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
                  onPressed: () {},
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