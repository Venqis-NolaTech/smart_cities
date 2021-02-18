import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/spaces.dart';

import 'package:smart_cities/src/shared/app_colors.dart';
import '../../../domain/entities/place.dart';
import '../../../../../shared/components/base_view.dart';
import '../provider/place_comment_provider.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../../shared/components/comment_item_place.dart';
import '../../../../../shared/components/place_title_header.dart';
import '../../../../../../generated/i18n.dart';
import '../../../../../core/error/failure.dart';

class PlaceCommentPage extends StatefulWidget {
  static const id = "place_comment_page";

  final Place place;
  const PlaceCommentPage({Key key, this.place}) : super(key: key);

  @override
  _PlaceCommentPageState createState() => _PlaceCommentPageState();
}

class _PlaceCommentPageState extends State<PlaceCommentPage> {
  ScrollController _scrollController;
  PlaceCommentProvider _provider;

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

  @override
  Widget build(BuildContext context) {
    return BaseView<PlaceCommentProvider>(
        onProviderReady: (provider) => provider.getComments(widget.place.id),
        builder: (context, provider, child) {
          final currentState = provider.currentState;

          provider.onDataFecthed = _moveDownScroll;

          _provider = provider;

          return ModalProgressHUD(
            inAsyncCall: currentState is Loading,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.red,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text(S.of(context).comments),
                leading: IconButton(
                  icon: Icon(MdiIcons.arrowLeft),
                  color: AppColors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Container(
                color: AppColors.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Spaces.verticalMedium(),
                    Container(padding: EdgeInsets.only(left: 24.0, right: 24.0), child: PlaceTitleHeader(place: widget.place)),
                    Spaces.verticalMedium(),
                    Expanded(
                      child: Scrollbar(
                        child: StreamBuilder<List<LastComment>>(
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
            ),
          );
        });
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

  Widget _buildList(List<LastComment> comments, PlaceCommentProvider provider) {
    return RefreshIndicator(
      onRefresh: provider.refreshData,
      child: ListView.builder(
        itemCount: comments.length,
        controller: _scrollController,
        itemBuilder: (context, index) => PlaceCommentItem(
          comment: comments[index],
          isLast: index == comments.length - 1,
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return InfoView(
      height: MediaQuery.of(context).size.height,
      image: Container(
        height: 48,
        child: AppImages.empyteComment,
      ),
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
