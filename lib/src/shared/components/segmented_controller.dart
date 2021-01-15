import 'package:flutter/material.dart';

import '../app_colors.dart';
import 'custom_card.dart';

class SegmentedController<T> extends StatelessWidget {
  SegmentedController({
    Key key,
    @required this.children,
    @required this.onValueChanged,
    this.groupValue,
    this.selectedColor = AppColors.blueButton,
    this.unselectedColor = Colors.white,
  }) : super(key: key);

  final Color selectedColor;
  final Color unselectedColor;
  final Map<T, String> children;
  final ValueChanged<T> onValueChanged;
  final T groupValue;

  List<Widget> _mapWidgets(double width) {
    final padding = EdgeInsets.symmetric(vertical: 10.0, horizontal: 32.0);

    return children.entries
        .map(
          (c) => InkWell(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              width: width,
              padding: padding,
              color: groupValue == c.key ? selectedColor : unselectedColor,
              child: Text(
                c.value.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: groupValue == c.key ? unselectedColor : selectedColor,
                  fontSize: 12.0,
                ),
              ),
            ),
            onTap: () => onValueChanged(c.key),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = (MediaQuery.of(context).size.width / 2) - 16;

    return Container(
      padding: EdgeInsets.all(16.0),
      child: CustomCard(
        shadowOffset: Offset(0.0, 4.0),
        shadowColorAlpha: 16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: _mapWidgets(width),
        ),
      ),
    );
  }
}
