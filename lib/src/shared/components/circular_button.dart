import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({
    Key key,
    this.size = 56,
    this.child,
    this.color = Colors.white,
    this.splashColor,
    this.onPressed,
  }) : super(key: key);

  final double size;
  final Function onPressed;
  final Widget child;
  final Color color;
  final Color splashColor;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          splashColor: splashColor,
          child: SizedBox(
            width: size,
            height: size,
            child: child,
          ),
          onTap: onPressed,
        ),
      ),
    );
  }
}
