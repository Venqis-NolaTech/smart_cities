import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/src/features/resports/presentation/report_details/pages/report_details_page.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/constant.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/util/string_util.dart';
import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/components/comment_box.dart';
import '../../../../../shared/components/comment_item.dart';
import '../../../../../shared/components/info_alert_dialog.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/entities/report.dart';
import '../providers/report_comments_provider.dart';

class ReportCommentsPage extends StatefulWidget {
  static const id = "report_comments_page";

  ReportCommentsPage({
    Key key,
    @required this.report,
  }) : super(key: key);

  final Report report;

  @override
  _ReportCommentsPageState createState() => _ReportCommentsPageState();
}

class _ReportCommentsPageState extends State<ReportCommentsPage> {
  final TextEditingController _textController = TextEditingController();

  ScrollController _scrollController;
  ReportCommentsProvider _provider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);

    refreshComment.listen((event) {
      print('actualizar comment');
      _provider?.refreshData();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController?.dispose();

    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _provider?.fetchData();
    }
  }

  void _moveDownScroll() {
    _scrollController.animateTo(
      _scrollController.position.pixels + 80,
      duration: Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<bool> _sendComment(ReportCommentsProvider provider) async {
    //await provider.createComment();

    return _proccessPostComment(provider);
  }
  void refresComment(){

  }
  bool _proccessPostComment(ReportCommentsProvider provider) {
    final commentPostState = provider.commentPostState;

    String titleDialog = S.of(context).info;
    String messageDialog = S.of(context).reportCommentSuccessMessage;
    bool success = true;

    if (commentPostState is Error) {
      titleDialog = S.of(context).error;
      messageDialog = S.of(context).unexpectedErrorMessage;
      success = false;
    }

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
    return BaseView<ReportCommentsProvider>(
      onProviderReady: (provider) => provider.getComments(widget.report.id),
      builder: (context, provider, child) {
        final currentState = provider.currentState;

        provider.onDataFecthed = _moveDownScroll;

        _provider = provider;

        final isCommetAllow =
            _provider.currentState is Idle || provider.currentState is Loaded;

        return ModalProgressHUD(
          inAsyncCall: currentState is Loading,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Scrollbar(
                      child: StreamBuilder<List<ReportComment>>(
                        stream: provider.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.isEmpty) {
                              return _buildEmptyView();
                            } else {
                              final comments = snapshot.data;
                              return Stack(children: <Widget>[
                                _buildList(comments, provider),
                                _buildLoadingIndicator(provider.isLoading),
                              ]);
                            }
                          } else if (snapshot.hasError) {
                            return _buildErrorView(context, snapshot.error);
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),



        );
      },
    );
  }

  Widget _buildLoadingIndicator(bool isLoading) {
    return isLoading
        ? Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 4.0,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade100,
                ),
              ),
            ],
          )
        : SizedBox.shrink();
  }

  Widget _buildList(
      List<ReportComment> comments, ReportCommentsProvider provider) {
    return RefreshIndicator(
      onRefresh: provider.refreshData,
      child: ListView.builder(
        itemCount: comments.length,
        controller: _scrollController,
        itemBuilder: (context, index) => CommentItem(
          comment: comments[index],
          isLast: index == comments.length - 1,
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return InfoView(
      height: MediaQuery.of(context).size.height,
      image: Container(height: 48, child: AppImages.empyteComment,),
      title: S.of(context).empyteComment,
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      description: S.of(context).messageComment,
      descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
    );
  }

  Widget _buildErrorView(BuildContext context, Failure failure) {
    return InfoView(
      height: MediaQuery.of(context).size.height,
      image: Container(height: 48),
      title: S.of(context).error,
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      description: S.of(context).unexpectedErrorMessage,
      descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
    );
  }
}
