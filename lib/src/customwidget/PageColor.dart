import 'package:flutter/material.dart';

class PageColor extends StatelessWidget {
  final Color color;
  PageColor(this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}