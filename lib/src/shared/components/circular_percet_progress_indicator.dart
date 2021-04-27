import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../constant.dart';

class CircularPercentProgressIndicator extends StatelessWidget {
  const CircularPercentProgressIndicator({
    Key key,
    @required this.progress,
    this.width = 56.0,
    this.height = 56.0,
  }) : super(key: key);

  final double progress;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
            width: width,
            height: height,
            child: CircularProgressIndicator(
              value: progress,
              backgroundColor:
                  progress != null ? AppColors.backgroundLight : null,
            )),
        progress != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: kSmallTextStyle.copyWith(
                      color: AppColors.primaryTextDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
