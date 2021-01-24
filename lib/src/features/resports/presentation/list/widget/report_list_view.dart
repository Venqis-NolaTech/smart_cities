
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/resports/presentation/list/provider/general_report_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/list/widget/report_list_item.dart';
import 'package:smart_cities/src/features/resports/presentation/report_details/pages/report_details_page.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/shared/app_images.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/provider/paginated_provider.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/entities/report.dart';


class ReportListView<P extends PaginatedProvider<Report>>
    extends StatefulWidget {
  ReportListView({
    Key key,
    final this.onProviderReady = true,
    final this.onlyConsumerProvider = false,
    this.isMyReport= false,
    this.currentLocation,
    this.topAndBottomPaddingEnabled = false,
  }) : super(key: key);

  final bool onProviderReady;
  final bool onlyConsumerProvider;
  final bool topAndBottomPaddingEnabled;
  final Position currentLocation;
  final bool isMyReport;

  @override
  ReportListViewState createState() => ReportListViewState<P>();
}

class ReportListViewState<P extends PaginatedProvider<Report>> extends State<ReportListView> {
  ScrollController _scrollController;
  P _provider;
  Position currentLocation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.dispose();

    super.dispose();
  }

  void refresh() {
    _provider?.refreshData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _provider?.fetchData();
    }
  }

  void _moveDownScroll() {
    _scrollController.animateTo(
      _scrollController.position.pixels + 60,
      duration: Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _onProviderReady(P provider) {
    if (widget.onProviderReady) {
      provider.fetchData();
    }
  }

  List<Report> reports=[];


  @override
  Widget build(BuildContext context) {
    final onlyConsumer = widget.onlyConsumerProvider;

    return BaseView<P>(
      onProviderReady: _onProviderReady,
      onlyConsumer: onlyConsumer,
      builder: (context, provider, child) {
        if (!widget.topAndBottomPaddingEnabled)
          provider.onDataFecthed = _moveDownScroll;

        _provider = provider;

        final currentState = provider.currentState;

        if (currentState is Error) {
          final failure = currentState.failure;

          return _buildErrorView(context, failure);
        }

        return ModalProgressHUD(
          inAsyncCall: currentState is Loading,
          child: Scrollbar(
            child: StreamBuilder<List<Report>>(
              stream: provider.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isEmpty) {
                    return _buildEmptyView();
                  } else {
                    reports = snapshot.data;
                    return Stack(children: <Widget>[
                      _buildList(reports, provider),
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

  Widget _buildList(List<Report> reports, P provider) {
    if(widget.currentLocation==null)
      return Container();

    return RefreshIndicator(
      onRefresh: provider.refreshData,
      child: ListView.builder(
        itemCount: reports.length,
        controller: _scrollController,
        itemBuilder: (context, index) => ReportListItem(
          report: reports[index],
          isFirst: index == 0,
          isLast: index == reports.length - 1,
          isMyReport: widget.isMyReport,
          currentLocation: widget.currentLocation,
          topAndBottomPaddingEnabled: widget.topAndBottomPaddingEnabled,
          onTap: () => Navigator.pushNamed(
            context,
            ReportDetailsPage.id,
            arguments: reports[index],
          ),
          onFollow: () => _onFollow(index, reports[index], provider),
        ),
      ),
    );
  }

  void _onFollow(int index, Report report, P provider) async {

    if(provider is GeneralReportProvider){
      await provider.followReport(report);
      _process(index, provider);
      /*reports[index].follow= true;
      setState(() {

      });*/
    }
  }


  Widget _buildEmptyView() {
    return InfoView(
      height: MediaQuery.of(context).size.height*0.7,
      image: AppImages.iconMessage,
      title: S.of(context).reportNotFound,
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      //description: S.of(context).reportNotFound,
      //descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
    );
  }

  Widget _buildErrorView(BuildContext context, Failure failure) {
    return InfoView(
      height: MediaQuery.of(context).size.height*0.7,
      image: AppImages.iconMessage,
      title: S.of(context).error,
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      description: S.of(context).unexpectedErrorMessage,
      descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
    );
  }

  void _process(int index, P provider) {

    final currentState = provider.currentState;

    if (currentState is Loaded<Report>) {
      final reportUpdated = currentState.value;
      reports[index]= reportUpdated;
      setState(() {});
      return;
    }

    if (currentState is Error) {
      showDialog(
        context: context,
        builder: (context) {
          return InfoAlertDialog(
            message: S.of(context).unexpectedErrorMessage,
          );
        },
      );
    }

  }
}
