import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({
    @required this.title,
    this.defaultActionEneabled = true,
    this.customActions = const [],
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(20.0),
      ),
    ),
    this.elevation,
  });

  final String title;
  final ShapeBorder shape;
  final double elevation;
  final bool defaultActionEneabled;
  final List<Widget> customActions;

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => AppBar().preferredSize;
}

class _CustomAppBarState extends State<CustomAppBar> {
  //Image _avatar;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: widget.elevation,
      flexibleSpace: Ink(
        decoration: BoxDecoration(
          color: AppColors.blueButton,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
      ),
      shape: widget.shape,
      title: Text(
        widget.title,
      ),
      actions: widget.defaultActionEneabled
          ? <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () =>
                    {}, //Navigator.pushNamed(context, SearchPage.id),
              ),
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () =>
                    {}, //Navigator.pushNamed(context, ProfilePage.id),
              ),
              ...widget.customActions,
            ]
          : widget.customActions,
    );
  }
}
