import 'package:flutter/material.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';

import '../../../../../../app.dart';
import '../../../../../../generated/i18n.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../di/injection_container.dart' as di;
import '../../../../../shared/app_images.dart';
import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/components/info_view.dart';
import '../../../../../shared/components/loading_indicator.dart';
import '../../../../../shared/components/web_view_page.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../channels/domain/entities/channel.dart';
import '../../../domain/entities/survey.dart';
import '../providers/surveys_provider.dart';
import 'survey_item.dart';
import '../../../../../core/util/list_util.dart';

const surveyCallbackUrl = "/finish";

class SurveyList extends StatefulWidget {
  SurveyList({
    Key key,
    @required this.scrollController,
    @required this.onOptionMenuSelected,
  }) : super(key: key);

  final ScrollController scrollController;
  final Function(SurveyMenuOption, Survey) onOptionMenuSelected;

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

          return _buildErrorView(provider, failure);
        }

        return Column(
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
        );
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

            final draftList = surveys.where((s) => !s.public).toList();
            final publicList = surveys.where((s) => s.public).toList();

            final children = List<Widget>();

            final hasDraft = draftList.isNotNullOrNotEmpty;
            final hasPublic = publicList.isNotNullOrNotEmpty;

            if (hasPublic) {
              children.add(
                _buildList(publicList, provider),
              );
            }

            if (hasDraft) {
              if (hasPublic) {
                children.add(
                  Container(
                    color: AppColors.blueDark,
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      S.of(context).drafts,
                      textAlign: TextAlign.center,
                      style: kSmallTextStyle.copyWith(color: Colors.white),
                    ),
                  ),
                );
              }

              children.add(
                _buildList(draftList, provider),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
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

  Widget _buildList(List<Survey> surveys, SurveysProvider provider) {
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: surveys.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final bool isLast = index == surveys.length - 1;
        final survey = surveys[index];

        final fileItem = SurveyItem(
          permission: null,
          survey: survey,
          onPressed: survey.public ? () => _gotoSurveyDetail(survey) : null,
          onOptionMenuSelected: (option) =>
              widget.onOptionMenuSelected(option, survey),
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
      },
      separatorBuilder: (context, index) {
        return Divider(height: 1.0, color: Colors.grey);
      },
    );
  }

  Widget _buildEmptyView() {
    return InfoView(
      title: S.of(context).emptySurveyMessage,
      image: AppImages.warning,
    );
  }

  Widget _buildErrorView(SurveysProvider provider, Failure failure) {
    String message = failure is NotConnectionFailure
        ? S.of(context).noConnectionMessage
        : S.of(context).unexpectedErrorMessage;

    Image image = failure is NotConnectionFailure
        ? AppImages.noConnection
        : AppImages.warning;

    return InfoView(
      title: message,
      image: image,
      titleAction: S.of(context).tryAgain,
      actionPressed: () => provider.refreshData(),
    );
  }
}
