import 'package:flutter/material.dart';

import '../app_colors.dart';

class CustomItemList extends StatefulWidget {
  final bool selected;
  final Function onTap;
  final String title;
  final bool isDivider;
  final TextStyle textStyle;


  const CustomItemList({Key key, this.selected, this.onTap, this.title, this.isDivider, this.textStyle}) : super(key: key);


  @override
  _CustomItemListState createState() => _CustomItemListState();
}

class _CustomItemListState extends State<CustomItemList> {


  @override
  Widget build(BuildContext context) {

    return Container(
      color:   widget.selected ? AppColors.green : Colors.transparent,
      child: Column(
        children: [
          ListTile(
            onTap: widget.onTap,
            title: Text(widget.title,
                textAlign: TextAlign.center,
                style: widget.textStyle ?? TextStyle(
                  color: widget.selected
                      ? AppColors.white
                      : AppColors.textItem,
                  fontWeight: widget.selected ? FontWeight.bold : FontWeight.w400 ,
                )
            ),
          ),
          widget.isDivider ? Container(color: AppColors.greyButtom.withOpacity(0.5), height: 0.6,) : Container(),
        ],
      ),
    );
  }
}
