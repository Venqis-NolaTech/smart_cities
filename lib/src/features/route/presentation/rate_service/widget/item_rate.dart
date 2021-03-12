import 'package:flutter/material.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';


class ItemRate extends StatefulWidget {
  final String title;
  final bool selected;
  final Function onSelect;

  ItemRate({Key key, this.onSelect, this.title, this.selected}) : super(key: key);

  @override
  _ItemRateState createState() => _ItemRateState();
}

class _ItemRateState extends State<ItemRate> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.onSelect();
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryText.withOpacity(0.02),
          border: Border.all(color: widget.selected ?  AppColors.greenCompleted.withOpacity(0.5) : AppColors.primaryText.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                  child: Text(widget.title, style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister),
              )),
              widget.selected ? _buildCircleDone() : _buildCircleEmpty()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleDone(){
    return Container(
      height: 30,
      width: 30,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color:  AppColors.greenCompleted,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
            color: AppColors.greenCompleted
        ),

      ),
      child: Icon(Icons.done, color: AppColors.white, size: 20),
    );
  }

  Widget _buildCircleEmpty(){
    return Container(
      height: 30,
      width: 30,
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
            color: AppColors.primaryTextLight
        ),

      ),
    );
  }
}
