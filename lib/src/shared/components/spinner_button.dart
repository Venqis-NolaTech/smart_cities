import 'package:flutter/material.dart';

import '../app_colors.dart';

class SpinnerIconButton extends StatefulWidget {
  SpinnerIconButton({
    Key key,
    this.width = 36.0,
    this.height = 36.0,
    this.padding,
    this.icon,
    this.enabled,
    this.backgroundColor = AppColors.blueButton,
    this.iconColor = Colors.white,
    this.indicatorProgressColor = Colors.white,
    @required this.onPressed,
  }) : super(key: key);

  final double width;
  final double height;
  final EdgeInsets padding;
  final Color indicatorProgressColor;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final bool enabled;
  final Function onPressed;

  @override
  _SpinnerIconButtonState createState() => _SpinnerIconButtonState();
}

class _SpinnerIconButtonState extends State<SpinnerIconButton> {
  bool _loading = false;

  set loading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: InkWell(
        child: ClipOval(
          child: Material(
            elevation: 4.0,
            child: Container(
              width: widget.width,
              height: widget.height,
              color: widget.backgroundColor,
              child: Center(
                child: _loading
                    ? SizedBox(
                        height: 16.0,
                        width: 16.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.indicatorProgressColor,
                          ),
                        ),
                      )
                    : Icon(
                        widget.icon,
                        size: 16.0,
                        color: widget.iconColor,
                      ),
              ),
            ),
          ),
        ),
        onTap: widget.enabled && !_loading
            ? () async {
                loading = true;

                await widget.onPressed();

                loading = false;
              }
            : null,
      ),
    );
  }
}
