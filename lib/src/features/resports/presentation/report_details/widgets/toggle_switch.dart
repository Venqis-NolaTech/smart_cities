import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:meta/meta.dart';


class ToggleSwitch extends StatefulWidget {
  final Function(int) onChangedIndex;
  final int index;
  const ToggleSwitch({Key key, @required this.onChangedIndex, @required this.index}) : super(key: key);


  @override
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  final activeBgColor = AppColors.blueBtnRegister;
  final activeFgColor =  AppColors.blueBtnRegister;
  final inactiveBgColor =  Colors.white;
  final inactiveFgColor =  AppColors.blueBtnRegister;

  @override
  Widget build(BuildContext context) {
    final screenHeight= MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight*0.07,
      alignment: Alignment.center,
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
      child:
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildLeftButtom(widget.index==0, S.of(context).reportSingle, context),
          buildRightButtom(widget.index==1, S.of(context).comments, context),
        ],
      ),
    );
  }

  Widget buildLeftButtom(bool isSelected, String title, BuildContext context){
    return GestureDetector(
      onTap: () => _selectedIndex(0),
      child: Container(
        decoration: BoxDecoration(
          color: !isSelected ? inactiveBgColor : activeBgColor,
          border: Border.all(color: activeBgColor),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          )
        ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 80,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: kNormalStyle.copyWith(color: isSelected ? inactiveBgColor : activeBgColor ),),
            ),
          )
      ),
    );
  }


  Widget buildRightButtom(bool isSelected, String title, BuildContext context){
    return GestureDetector(
      onTap: () => _selectedIndex(1),
      child: Container(
          decoration: BoxDecoration(
              color: !isSelected ? inactiveBgColor : activeBgColor,
              border: Border.all(color: activeBgColor),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)
              )
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 80,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: kNormalStyle.copyWith(color: isSelected ? inactiveBgColor : activeBgColor ),),
            ),
          )
      ),
    );
  }

  void _selectedIndex(int ix) {
    /*setState(() {
      index= ix;
    });*/
    widget.onChangedIndex(ix);
  }
}
