import 'package:flutter/material.dart';

class BubbleText extends StatelessWidget {
  BubbleText(
    this.text, {
    this.textAlign,
    this.style,
    this.color,
    this.borderColor,
    this.borderRadius = 4,
    this.padding,
    this.onTap,
  });

  final Color borderColor;
  final double borderRadius;
  final Color color;
  final String text;
  final TextAlign textAlign;
  final TextStyle style;
  final EdgeInsets padding;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
       borderRadius: BorderRadius.circular(8.0),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          side: BorderSide(
            color: borderColor ?? Colors.transparent,
          ),
        ),
        color: color ?? Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: padding ??
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            child: Center(
              child: Text(
                text,
                textAlign: textAlign,
                style: style,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
