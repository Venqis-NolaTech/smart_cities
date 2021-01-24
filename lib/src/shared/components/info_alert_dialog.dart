import 'package:flutter/material.dart';

import '../../../generated/i18n.dart';
import '../app_colors.dart';
import '../spaces.dart';
import '../../core/util/string_util.dart';

class InfoAlertDialog extends StatelessWidget {
  InfoAlertDialog({
    this.image,
    this.title = "",
    @required this.message,
    this.confirmTitle,
    this.cancelTitle,
    this.onConfirm,
    this.onCancel,
    this.cancelAction = false,
    this.disableExecuteActions = false,
    this.textAlign = TextAlign.center,
  });

  final Widget image;
  final String title;
  final String message;
  final Function onConfirm;
  final Function onCancel;
  final String confirmTitle;
  final String cancelTitle;
  final bool cancelAction;
  final bool disableExecuteActions;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(25.0),
            child: Column(
              children: _buildContentDialog(),
            ),
          ),
          Divider(
            height: 0.5,
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: _buildBottomDialog(context),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildContentDialog() {
    final widgets = <Widget>[];

    if (image != null) {
      widgets.addAll(
        [
          SizedBox(
            height: 120.0,
            width: 120.0,
            child: image,
          ),
          Spaces.verticalMedium(),
        ],
      );
    }

    if (title.isNotNullOrNotEmpty) {
      widgets.addAll(
        [
          Text(
            title,
            textAlign: textAlign,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.blueBtnRegister,
            ),
          ),
          Spaces.verticalMedium(),
        ],
      );
    }

    widgets.add(
      Text(
        message,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: 14.0,
          color: AppColors.blueBtnRegister,
        ),
      ),
    );

    return widgets;
  }

  Widget _buildBottomDialog(BuildContext context) {
    final actions = <Widget>[];

    if (cancelAction) {
      actions.add(
        FlatButton(
          child: Text(cancelTitle ?? S.of(context).cancel),
          onPressed: () {
            if (!disableExecuteActions) Navigator.pop(context);

            if (onCancel != null) onCancel();
          },
        ),
      );
    }

    actions.add(
      FlatButton(
        child: Text(confirmTitle ?? S.of(context).ok, style: TextStyle(color: AppColors.blueLight),),
        onPressed: () {
          if (!disableExecuteActions) Navigator.pop(context);

          if (onConfirm != null) onConfirm();
        },
      ),
    );

    return Row(
      mainAxisAlignment: actions.length > 1
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.spaceAround,
      children: actions,
    );
  }
}
