import 'package:flutter/material.dart';

import '../constant.dart';

class RoundedGradientButton extends StatelessWidget {


  RoundedGradientButton({
    @required this.colors,
    this.textColor = Colors.white,
    @required this.title,
    @required this.onPressed,
    this.height = 48.0,
    this.style
  });

  final List<Color> colors;
  final Color textColor;
  final String title;
  final Function onPressed;
  final double height;
  final TextStyle style;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: RaisedButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.all(Radius.circular(80.0)),
          ),
          child: Container(
            constraints: BoxConstraints(minWidth: 88.0, minHeight: 55.0),
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: style ??  kNormalStyle.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              )
            ),
          ),
        ),
      ),
    );
  }
}
