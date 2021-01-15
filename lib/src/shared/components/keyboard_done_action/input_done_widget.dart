import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../generated/i18n.dart';

class InputDoneView extends StatelessWidget {
  const InputDoneView({Key key, this.onDone}) : super(key: key);

  final Function onDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: CupertinoButton(
            padding: EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
            onPressed: () {
              if (onDone != null) onDone();

              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Text(
              S.of(context).done,
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
