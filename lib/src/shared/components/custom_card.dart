import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard({
    Key key,
    this.blurRadius: 8.0,
    this.borderRadius,
    this.border,
    this.shadowColor: const Color(0xFF000000),
    this.backgroundColor: Colors.white,
    this.shadowColorAlpha: 8,
    this.shadowOffset: const Offset(0.0, 2.0),
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.child,
    this.onTap,
    this.constraints,
    this.image,
  }) : super(key: key);

  final BorderRadiusGeometry borderRadius;
  final BoxBorder border;
  final double blurRadius;
  final Color shadowColor;
  final Color backgroundColor;
  final int shadowColorAlpha;
  final Offset shadowOffset;
  final double height;
  final double width;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Widget child;
  final Function onTap;
  final BoxConstraints constraints;
  final DecorationImage image;

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(8.0);

    return Container(
      margin: margin,
      constraints: constraints,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: border,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withAlpha(shadowColorAlpha),
            offset: shadowOffset,
            blurRadius: blurRadius,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Material(
          elevation: 0.0,
          borderRadius: borderRadius,
          color: backgroundColor,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: height,
              width: width,
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                image: image,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
