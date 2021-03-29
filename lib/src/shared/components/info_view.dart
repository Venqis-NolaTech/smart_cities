import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'rounded_button.dart';

import '../app_colors.dart';
import '../constant.dart';
import '../spaces.dart';

class InfoView extends StatelessWidget {
  InfoView({
    this.height = 100.0,
    this.image,
    this.title,
    this.description,
    this.titleStyle = kMediumTitleStyle,
    this.descriptionStyle = kNormalStyle,
    this.titleAction,
    this.actionPressed,
    this.child,
  });

  final double height;
  final Widget image;
  final String title;
  final String description;
  final TextStyle titleStyle;
  final TextStyle descriptionStyle;
  final String titleAction;
  final Function actionPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: AppColors.background,
        constraints: BoxConstraints(minHeight: height),
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            image,
            Spaces.verticalMedium(),
            Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: titleStyle,
            ),
            Spaces.verticalMedium(),
            Text(
              description ?? '',
              textAlign: TextAlign.center,
              style: descriptionStyle,
            ),
            Spaces.verticalLarge(),
            if (child != null) child,
            actionPressed != null ? Spaces.verticalMedium() : Container(),
            actionPressed != null
                ? RoundedButton(
                    color: AppColors.red,
                    title: titleAction,
                    trailingIcon: Icon(MdiIcons.chevronRight),
                    style: kNormalStyle.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    onPressed: actionPressed,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
