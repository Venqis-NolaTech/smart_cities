import 'package:flutter/material.dart';

import '../../../generated/i18n.dart';
import '../app_colors.dart';
import '../app_images.dart';
import '../constant.dart';
import '../spaces.dart';

class CommentBox extends StatefulWidget {
  CommentBox({
    this.buttonEnabled = false,
    this.inputEnabled = false,
    @required this.textController,
    @required this.onTextChanged,
    @required this.onIsAnonymousChanged,
    @required this.sendAction,
    @required this.addPhotoAction,
  });

  final bool buttonEnabled;
  final bool inputEnabled;
  final TextEditingController textController;
  final Function(String) onTextChanged;
  final Function(bool) onIsAnonymousChanged;
  final Function sendAction;
  final Function addPhotoAction;

  @override
  _CommentBoxState createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  bool isVisible = false;
  bool isAnonymous = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1.5,
          ),
        ),
      ),
      child: Column(
        children: [
          Visibility(
            visible: isVisible,
            child: Row(
              children: [
                Checkbox(
                  value: isAnonymous,
                  onChanged: (value) {
                    setState(() {
                      isAnonymous = value;
                      widget.onIsAnonymousChanged(isAnonymous);
                    });
                  },
                ),
                Text(
                  S.of(context).messageAnonymous,
                  style: kSmallTextStyle.copyWith(
                      color: AppColors.primaryTextLight.withOpacity(0.5)),
                )
              ],
            ),
          ),



          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppImages.iconComment,
              Spaces.horizontalSmall(),
              !isVisible
                  ? Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                              onPressed: () {
                                isVisible = !isVisible;
                                setState(() {});
                              },
                              child: Text(S.of(context).comment, style: kNormalStyle.copyWith(
                                  color: AppColors.blueLight),)),
                        ],
                      ),
                    )
                  : Flexible(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: TextField(
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 6,
                              enabled: widget.inputEnabled,
                              controller: widget.textController,
                              decoration: InputDecoration(
                                hintText: S.of(context).writeComment,
                                suffixIcon: IconButton(
                                  onPressed: widget.addPhotoAction,
                                  icon: Icon(
                                    Icons.add_a_photo,
                                    color:
                                        AppColors.primaryTextLight.withOpacity(0.7),
                                  ),
                                ),
                                border: InputBorder.none
                                //fillColor: Colors.grey.shade300,
                              ),
                              onChanged: widget.onTextChanged),
                        ),
                      ),
                    ),

              Spaces.horizontalSmallest(),
              Visibility(
                visible: isVisible,
                child: FlatButton(
                    onPressed: widget.buttonEnabled
                        ? () async {
                            bool success = await widget.sendAction();
                            if (success == true) {
                              widget.textController.clear();
                              isVisible = !isVisible;
                              setState(() {});
                            }
                          }
                        : null,
                    child: Text(S.of(context).send)),
              ),
            ],
          ),

          Spaces.verticalMedium(),
        ],
      ),
    );
  }
}
