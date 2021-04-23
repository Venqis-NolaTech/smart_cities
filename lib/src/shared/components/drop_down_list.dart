import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../constant.dart';
import '../app_colors.dart';


class DropDownList<T> extends StatelessWidget {
  DropDownList({
    Key key,
    @required this.title,
    @required this.items,
    @required this.itemSelected,
    @required this.onSelected,
    @required this.hintTitle
  }) : super(key: key);

  final String title;
  final String hintTitle;
  final List<T> items;
  final T itemSelected;
  final Function(T) onSelected;

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _DropDownListDialog<T>(
        items: items,
        itemSelected: itemSelected,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Material(
          child: Container(
            //margin: EdgeInsets.only(top: 4.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade600,
                width: 1.0,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            child: ListTile(
              title: Text(
                itemSelected == null
                    ?  hintTitle
                    : itemSelected.toString() ?? "",
                style: kNormalStyle.copyWith(
                  color: itemSelected == null ? Colors.grey : Colors.black,
                ),
              ),
              trailing: Icon(MdiIcons.chevronRight),
              onTap: () => _showDialog(context),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropDownListDialog<T> extends StatelessWidget {
  const _DropDownListDialog({
    Key key,
    @required this.items,
    @required this.itemSelected,
    @required this.onSelected,
  }) : super(key: key);

  final List<T> items;
  final T itemSelected;
  final Function(T) onSelected;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildListRow(context, items),
      ),
    );
  }

  List<Widget> _buildListRow(BuildContext context, List<T> rows) {
    return rows.map((item) {
      final isSelected = itemSelected != null && item == itemSelected;

      return Material(
        color: Colors.transparent,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          dense: true,
          title: _buildListTitle(item, isSelected),
          onTap: () {
            onSelected(item);

            Navigator.of(context).pop();
          },
        ),
      );
    }).toList();
  }

  Widget _buildListTitle(T item, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: isSelected ? AppColors.red : Colors.transparent,
      child: Text(
        item.toString(),
        style: kNormalStyle.copyWith(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
