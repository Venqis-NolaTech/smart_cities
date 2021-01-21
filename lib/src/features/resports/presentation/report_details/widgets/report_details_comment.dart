
import 'package:flutter/material.dart';
import 'package:smart_cities/src/features/resports/domain/entities/report.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/comment_box.dart';
import 'package:smart_cities/src/shared/components/comment_item.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../core/util/string_util.dart';

import '../providers/report_details_provider.dart';

class ReportDetailsComment extends StatelessWidget {
  ReportDetailsComment({
    Key key,
    @required this.report,
    @required this.controller,
    @required this.provider,
    @required this.addPhotoAction,
    @required this.onSendComment,
  }) : super(key: key);

  final Report report;
  final TextEditingController controller;
  final ReportDetailsProvider provider;
  final Function addPhotoAction;
  final Function onSendComment;

  Future<bool> _sendComment(BuildContext context) async {
    await provider.createComment();

    return _proccessPostComment(context);
  }

  bool _proccessPostComment(BuildContext context) {
    final commentPostState = provider.commentPostState;

    String titleDialog = S.of(context).info;
    String messageDialog = S.of(context).reportCommentSuccessMessage;
    bool success = true;

    if (commentPostState is Error) {
      titleDialog = S.of(context).error;
      messageDialog = S.of(context).unexpectedErrorMessage;
      success = false;
    }
    onSendComment();

    showDialog(
      context: context,
      builder: (context) {
        return InfoAlertDialog(
          title: titleDialog,
          message: messageDialog,
        );
      },
    );

    return success;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
          color: Colors.grey.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildCommentSection(context),
        ),
      ),
    );
  }

  List<Widget> _buildCommentSection(BuildContext context) {
    final isCommetAllow = provider.currentState is Idle || provider.currentState is Loaded;

    final children = List<Widget>();

    children.add(
      CommentBox(
        textController: controller,
        inputEnabled: isCommetAllow,
        buttonEnabled: provider.comment.isNotNullOrNotEmpty,
        onTextChanged: (value) => provider.comment = value,
        onIsAnonymousChanged: (value) => provider.isAnonymous= value,
        addPhotoAction: addPhotoAction,  //funciono para mostrar el widget que permite llegar al page de add photo
        sendAction: isCommetAllow ? () => _sendComment(context) : null,
      ),
    );

    return children;
  }



}
