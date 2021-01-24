import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

class HeaderSearch extends StatefulWidget {
  final Function(String) onChanged;

  const HeaderSearch({Key key, this.onChanged}) : super(key: key);

  @override
  _HeaderSearchState createState() => _HeaderSearchState();
}

class _HeaderSearchState extends State<HeaderSearch> {
  TextEditingController _queryTextController;

  @override
  void initState() {
    super.initState();
    _queryTextController = TextEditingController();

    _queryTextController.addListener(() {
      if (_queryTextController.text.isEmpty) {

      } else {

      }
      widget.onChanged(_queryTextController.text);
    });
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight= MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight*0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400],
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 3.0,
          ),
        ],
      ),
      child: Container(
        child: TextField(
          controller: _queryTextController,
          autofocus: false,
          //style: widget.textStyle ?? _defaultStyle(),
          decoration: _defaultDecoration(S.of(context).search),
        ),
      )
    );
  }


  InputDecoration _defaultDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white30
          : Colors.black38,
      hintStyle: TextStyle(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black38
            : Colors.white30,
        fontSize: 16.0,
      ),
      border: InputBorder.none,
    );
  }
}
