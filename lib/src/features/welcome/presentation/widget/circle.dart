import 'package:flutter/material.dart';


class Circle extends StatelessWidget {
  final double radius;
  final Color color;

  const Circle({Key key, @required this.radius, @required this.color}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius*2,
      height: radius*2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color
      ),
    );
  }
}

