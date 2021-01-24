import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final Color textColor;
  final double borderSize;

  final String title;
  final Widget trailingIcon;
  final Widget leadingIcon;
  final TextStyle style;
  final double elevation;
  final double borderRadius;
  final Function onPressed;
  final double minWidth;
  final double minHeight;
  final double height;

  RoundedButton({
    @required this.color,
    this.borderColor = Colors.transparent,
    this.textColor = Colors.white,
    this.borderSize = 1.0,
    this.style,
    this.elevation,
    this.borderRadius = 80.0,
    @required this.title,
    this.trailingIcon,
    this.leadingIcon,
    @required this.onPressed,
    this.minWidth = 88.0,
    this.minHeight = 40.0,
    this.height = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    var btnColor = color;
    var btnBorderColor = borderColor;

    if (onPressed == null) {
      btnColor = Colors.grey.shade300;
      btnBorderColor = borderColor != Colors.transparent ? null : borderColor;
    }

    return SizedBox(
      height: height,
      child: RaisedButton(
        onPressed: onPressed,
        elevation: elevation,
        disabledColor: Colors.grey.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
            color: btnBorderColor,
            style: BorderStyle.solid,
            width: borderSize,
          ),
        ),
        padding: EdgeInsets.zero,
        color: btnColor,
        child: Ink(
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          child: Container(
            constraints: BoxConstraints(
              minWidth: minWidth,
              minHeight: minHeight,
            ),
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            height: height,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: <Widget>[
                _buildTitle(),
                _buildLeadingIcon(),
                _buildTrailingIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Positioned.fill(
        child: Align(
      alignment: Alignment.center,
      child: Text(title, textAlign: TextAlign.center, style: style),
    ));
  }

  Widget _buildLeadingIcon() {
    return Positioned(
      left: 10,
      top: 0.0,
      bottom: 0.0,
      child: leadingIcon != null
          ? SizedBox(
              width: 24.0,
              height: 24.0,
              child: leadingIcon,
            )
          : SizedBox.shrink(),
    );
  }

  Widget _buildTrailingIcon() {
    return Positioned(
      right: 0.0,
      top: 0.0,
      bottom: 0.0,
      child: trailingIcon != null
          ? SizedBox(
              width: 24.0,
              height: 24.0,
              child: trailingIcon,
            )
          : SizedBox.shrink(),
    );
  }
}
