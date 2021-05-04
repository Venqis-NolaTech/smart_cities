import 'package:flutter/material.dart';

import '../../../../../../app.dart';
import '../../../../../../generated/i18n.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../shared/app_images.dart';
import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/components/info_view.dart';
import '../../../../../shared/components/loading_indicator.dart';
import '../../../../../shared/components/web_view_page.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/entities/survey.dart';
import '../providers/surveys_provider.dart';
import 'survey_item.dart';

const surveyCallbackUrl = "/finish";

class SurveyList extends StatefulWidget {
  SurveyList({
    Key key,
    @required this.scrollController,
  }) : super(key: key);

  final ScrollController scrollController;


  @override
  _SurveyListState createState() => _SurveyListState();
}

class _SurveyListState extends State<SurveyList> {
  SurveysProvider _provider;

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (widget.scrollController.position.pixels ==
            widget.scrollController.position.maxScrollExtent &&
        ((_provider?.totalCount ?? 0) > 0)) {
      _provider?.fetchData();
    }
  }

  void _gotoSurveyDetail(Survey survey) {
    WebViewPage.pushNavigate(
          context,
          args: WebViewArgs(
            title: survey.name,
            url: survey.link,
            callbackUrl: surveyCallbackUrl,
            headers: authHeaders,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SurveysProvider>(
      onlyConsumer: true,
      builder: (context, provider, child) {
        _provider = provider;

        final currentState = provider.currentState;

        if (currentState is Error) {
          final failure = currentState.failure;

          return  _buildErrorView(provider, failure);
        }

        return _buildSurveys(_provider);
        /*return Column(
          children: <Widget>[
            IndexedStack(
              index: currentState is Loading ? 0 : 1,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 1.6,
                  child: LoadingIndicator(),
                ),
                _buildSurveys(_provider),
              ],
            ),
          ],
        );*/
      },
    );
  }

  Widget _buildSurveys(SurveysProvider provider) {
    return StreamBuilder<List<Survey>>(
      stream: provider.stream,
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            if (provider.currentState is Loading || provider.isLoading)
              return SizedBox.shrink();

            return _buildEmptyView();
          } else {
            final surveys = snapshot.data;  
       
            return Column(
              //mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildList(surveys, provider),
            );
          }
        } else if (snapshot.hasError) {
          return _buildErrorView(provider, snapshot.error);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildLoadingIndicator(bool isLoading) {
    return isLoading ? LoadingIndicator() : SizedBox.shrink();
  }

  List<Widget> _buildList(List<Survey> surveys, SurveysProvider provider) {

    return List.generate(surveys.length, (index) {
        final bool isLast = index == surveys.length - 1;
        final survey = surveys[index];

        final fileItem = SurveyItem(
          survey: survey,
          onPressed: survey.public ? () => _gotoSurveyDetail(survey) : null,
          onOptionMenuSelected: (option) => {},
        );

        if (isLast) {
          return Wrap(
            key: Key(index.toString()),
            children: [
              fileItem,
              _buildLoadingIndicator(provider.isLoading),
            ],
          );
        }

        return fileItem;
    });




    /*return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      itemCount: surveys.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
    
      },
      separatorBuilder: (context, index) {
        return Divider(height: 1.0, color: Colors.grey);
      },
    );*/
  }

  Widget _buildEmptyView() {
    return InfoView(
      title: S.of(context).emptySurveyMessage,
      image: AppImages.iconMessage,
    );
  }

  Widget _buildErrorView(SurveysProvider provider, Failure failure) {
    String message = failure is NotConnectionFailure
        ? S.of(context).noConnectionMessage
        : S.of(context).unexpectedErrorMessage;

    Image image = AppImages.iconFailed;

    return InfoView(
      title: message,
      image: image,
      titleAction: S.of(context).tryAgain,
      actionPressed: () => provider.refreshData(),
    );
  }
}
