import 'dart:async';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/report_files.dart';
import 'package:smart_cities/src/features/reports/presentation/report_comments/pages/report_comments_page.dart';
import 'package:smart_cities/src/features/reports/presentation/report_details/providers/report_details_provider.dart';
import 'package:smart_cities/src/features/reports/presentation/report_details/widgets/add_photo_header.dart';
import 'package:smart_cities/src/features/reports/presentation/report_details/widgets/report_details_comment.dart';
import 'package:smart_cities/src/features/reports/presentation/report_details/widgets/report_details_completed.dart';
import 'package:smart_cities/src/features/reports/presentation/report_details/widgets/toggle_switch.dart';
import 'package:smart_cities/src/shared/app_colors.dart';

import '../../../../../../generated/i18n.dart';
import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/entities/report.dart';
import '../widgets/report_details_content.dart';
import '../widgets/report_details_header.dart';
import '../widgets/report_details_sub_header.dart';



final _refreshStreamController = StreamController<dynamic>.broadcast();
Stream<dynamic> get refreshComment => _refreshStreamController.stream;


class ReportDetailsPage extends StatefulWidget {
  static const id = "report_details_page";

  ReportDetailsPage({
    Key key,
    @required this.report,
  }) : super(key: key);

  final Report report;

  @override
  _ReportDetailsPageState createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends State<ReportDetailsPage> {
  final TextEditingController _textController = TextEditingController();
  final _headerKey = GlobalKey<ReportDetailsHeaderState>();

  Report _report;
  bool _isDisposed = false;
  bool _reportLoaded = false;
  int indexStack= 0;
  int indexUltimate= 0;
  bool addImage= false;

  set report(Report newReport) {
    if (_isDisposed) return;

    setState(() {
      _report = newReport;
      //_headerKey.currentState.setLiked(_report.follow);
    });

  }

  @override
  void initState() {
    _report = widget.report;

    super.initState();
  }

  @override
  void dispose() {
    _isDisposed = true;

    _report = null;
    _textController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight= MediaQuery.of(context).size.height;

    return BaseView<ReportDetailsProvider>(
      onProviderReady: (provider) => provider.getReportById(_report.id),
      builder: (context, provider, child) {
        final currentState = provider.currentState;

        if (!_reportLoaded && currentState is Loaded<Report>) {
          Future.delayed(
            Duration(milliseconds: 250),
            () => report = currentState.value,
          );

          _reportLoaded = true;

          //report = currentState.value;
        }


        return ModalProgressHUD(
          inAsyncCall: currentState is Loading,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text(S.of(context).report),
                centerTitle: true,
                backgroundColor: AppColors.red,
                bottom: PreferredSize(
                  preferredSize: Size.square(screenHeight * 0.07),
                  child: SizedBox(
                      height: screenHeight * 0.07,
                      child: ToggleSwitch(
                          onChangedIndex: _onChangedInde,
                          index: indexStack > 1 ? 0 : indexStack)),
                )),
            body: Stack(
              children: [

                IndexedStack(
                  index: indexStack,
                  children: [
                    buildDetail(provider),
                    buildComment(),
                    ReportFiles(provider: provider, addBottomPadding: true)
                  ],
                ),

                _report.reportStatus == ReportStatus.SolutionCompleted ? Container()
                : Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ReportDetailsComment(  //widget para enviar un nuevo comentario
                        report: _report,
                        controller: _textController,
                        provider: provider,
                        addPhotoAction: (){
                          if(indexStack!=2)
                            setState(() {
                              addImage= true;
                            });
                        },
                        onSendComment: (){
                          setState(() {
                            indexStack=indexUltimate;
                            addImage= false;
                          });
                          _refreshStreamController.add(null);
                        },
                      )
                    ],
                  ),
                ),


                addImage ? Padding(
                  padding: EdgeInsets.only(top: screenHeight*0.07),
                  child: AddPhotoHeader(takePhoto: (){
                    setState(() {
                      indexStack=2;
                      addImage= false;
                    });
                  }),
                ) : Container(),


              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildDetail(ReportDetailsProvider provider) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ReportDetailsHeader(
            key: _headerKey,
            report: _report,
            provider: provider,
            addPhoto: (){
              if(indexStack!=2)
                setState(() {
                  addImage= true;
                });
            },
          ),
          ReportDetailsSubHeader(
            report: _report,
            onFollow: () => onFollow(provider),
          ),
          _report.reportStatus == ReportStatus.SolutionCompleted ?
          ReportDetailsCompleted(report: _report) :
          ReportDetailsContent(
            report: _report,
          ),
        ],
      ),
    );
  }

  Widget buildComment() {

    return ReportCommentsPage(report: _report);

  }

  void _onChangedInde(int index) {
    indexStack= index;
    indexUltimate= index;
    addImage= false;
    setState(() {});
  }





  void onFollow(ReportDetailsProvider provider) async {
    await provider.likeReport();
    var currentState= provider.currentState;
    if (currentState is Loaded<Report>) {
      report = currentState.value;
    }
  }
}
