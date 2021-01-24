import 'package:flutter/material.dart';

import '../app_colors.dart';

class CircularIcon extends StatelessWidget {
  CircularIcon({
    Key key,
    this.height = 30,
    this.width = 30,
    this.backgroundColor = AppColors.red,
    this.color = Colors.white,
    @required this.icon,
    this.iconSize = 16,
  }) : super(key: key);

  final double height;
  final double width;
  final Color backgroundColor;
  final Color color;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: height,
        width: width,
        color: backgroundColor,
        child: Center(
          child: Icon(
            icon,
            size: iconSize,
            color: color,
          ),
        ),
      ),
    );
  }
}
