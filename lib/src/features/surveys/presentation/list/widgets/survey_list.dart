import 'package:flutter/material.dart';
import 'package:smart_cities/src/shared/provider/paginated_provider.dart';


import '../../../../../../app.dart';
import '../../../../../../generated/i18n.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../shared/app_images.dart';
import '../../../../../shared/components/info_view.dart';
import '../../../../../shared/components/loading_indicator.dart';
import '../../../../../shared/components/web_view_page.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../domain/entities/survey.dart';
import 'survey_item.dart';

const surveyCallbackUrl = "/finish";

class SurveyList extends StatefulWidget {
  SurveyList({
    Key key,
    @required this.scrollController,
    @required this.provider,
    @required this.allowActions,
    this.onOptionMenuSelected,
  }) : super(key: key);

  final ScrollController scrollController;
  final PaginatedProvider provider;
  final bool allowActions;
  final Function(SurveyMenuOption, Survey) onOptionMenuSelected;


  @override
  _SurveyListState createState() => _SurveyListState();
}

class _SurveyListState extends State<SurveyList> {

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (widget.scrollController.position.pixels ==
            widget.scrollController.position.maxScrollExtent &&
        ((widget.provider?.totalCount ?? 0) > 0)) {
      widget.provider?.fetchData();
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
    final currentState = widget.provider.currentState;

    if (currentState is Error) {
      final failure = currentState.failure;

      return  _buildErrorView(widget.provider, failure);
    }

    return _buildSurveys(widget.provider);
  }

  Widget _buildSurveys(PaginatedProvider provider) {


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
              mainAxisSize: MainAxisSize.min,
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

  List<Widget> _buildList(List<Survey> surveys, PaginatedProvider provider) {

    return List.generate(surveys.length, (index) {
        final bool isLast = index == surveys.length - 1;
        final survey = surveys[index];


        final fileItem = SurveyItem(
          survey: survey,
          isFirst: index == 0 || index == 1,
          topAndBottomPaddingEnabled: true,
          isLast: index == surveys.length - 1 || index == surveys.length - 2,
          allowActions: widget.allowActions,
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
    });
  }

  Widget _buildEmptyView() {
    return InfoView(
      title: S.of(context).emptySurveyMessage,
      image: AppImages.iconMessage,
    );
  }

  Widget _buildErrorView(PaginatedProvider provider, Failure failure) {
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
