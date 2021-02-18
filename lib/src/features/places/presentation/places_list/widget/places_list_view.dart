import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/features/auth/domain/entities/user.dart';
import 'package:smart_cities/src/features/places/presentation/places_detail/page/place_detail.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/provider/all_places_provider.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/provider/nearby_places_provider.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/widget/place_item.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';


import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/provider/paginated_provider.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';

import '../../../../../../app.dart';



class PlaceListView<P extends PaginatedProvider<Place>> extends StatefulWidget {
  PlaceListView({
    Key key,
    final this.onProviderReady= true,
    final this.onlyConsumerProvider = false,
    this.topAndBottomPaddingEnabled = false,
    this.category
  }) : super(key: key);

  final bool onProviderReady;
  final bool onlyConsumerProvider;
  final bool topAndBottomPaddingEnabled;
  final String category;

  @override
  _PlaceListViewState createState() => _PlaceListViewState<P>();
}

class _PlaceListViewState<P extends PaginatedProvider<Place>> extends State<PlaceListView> {
  ScrollController _scrollController;
  P _provider;
  Position currentLocation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(keepScrollOffset: false)..addListener(_scrollListener);
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

  Future<void> _onProviderReady(P provider) async {
    if (widget.onProviderReady) {
      if(provider is AllPlacesProvider){
        provider.category= widget.category;
        provider.municipality= currentUser.municipality.key;
      }else
      if(provider is NearbyPlacesProvider){
        provider.category= widget.category;
        provider.municipality= currentUser.municipality.key;
      }

      provider.fetchData();
    }

  }

  List<Place> places=[];


  @override
  Widget build(BuildContext context) {
    final onlyConsumer = widget.onlyConsumerProvider;
    final orientation = MediaQuery.of(context).orientation;


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
            child: StreamBuilder<List<Place>>(
              stream: provider.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isEmpty) {
                    return _buildEmptyView();
                  } else {
                    places = snapshot.data;
                    return Stack(children: <Widget>[
                      _buildList(places, provider, orientation),
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

  Widget _buildList(List<Place> places, P provider, Orientation orientation) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = 240;
    final double itemWidth = size.width / 2;

   return RefreshIndicator(
      onRefresh: provider.refreshData,
      child: GridView.count(
        crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
        shrinkWrap: true,
        controller: _scrollController,
        childAspectRatio: (itemWidth / itemHeight),

        children: getPlacesChildren(places, provider),
      ),
    );
  }

  List<Widget> getPlacesChildren(List<Place> places, P provider) {
    List<Widget> list= [];

    places.asMap().forEach((index, value) {
      list.add(PlaceItem(
          place: places[index],
          isFirst: index == 0 || index == 1,
          isLast: index == places.length - 1 || index == places.length - 2,
          currentLocation: provider is NearbyPlacesProvider ? provider.currentLocation : null,
          topAndBottomPaddingEnabled: widget.topAndBottomPaddingEnabled,
          onTap: () => Navigator.pushNamed(context, PlaceDetailsPage.id,
              arguments: places[index])));
    });
    return list;
  }


  Widget _buildEmptyView() {
    return InfoView(
      height: MediaQuery.of(context).size.height*0.7,
      image: AppImages.iconMessage,
      title: S.of(context).placesNotFound,
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



}
