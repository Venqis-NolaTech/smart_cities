import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/provider/all_places_provider.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/provider/nearby_places_provider.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/page/places_category_page.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/widget/nearby_places.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/widget/places_list_view.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/tab_bar_container.dart';

class PlacesPage extends StatefulWidget {
  static const id = "places_page";

  PlacesPage({
    Key key,
    @required this.category,
  }) : super(key: key);

  final String category;

  @override
  _PlacesPageState createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage>
    with SingleTickerProviderStateMixin {
  List<Widget> _widgetOptions;
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initWidget();
  }

  initWidget() {
    _widgetOptions = <Widget>[
      PlaceListView<AllPlacesProvider>(
        topAndBottomPaddingEnabled: false,
        category: widget.category,
      ),
      PlaceListView<NearbyPlacesProvider>(
        topAndBottomPaddingEnabled: false,
        category: widget.category,
      ),
      NearbyPlaces(category: widget.category)
    ];

    _tabController = TabController(vsync: this, length: _widgetOptions.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _widgetOptions,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.red,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(S.of(context).sitesTourist),
      leading: IconButton(
        icon: Icon(MdiIcons.arrowLeft),
        color: AppColors.white,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        IconButton(
            onPressed: () async {
              Navigator.pushReplacementNamed(context, PlacesCategoryPage.id,
                  arguments: widget.category);

              /*if(result!=null){
                  print('hay un valor valido');
                }*/
            },
            icon: Icon(
              Icons.tune,
              color: AppColors.white,
            )),
      ],
      bottom: TabBarContainer(
        color: AppColors.white,
        tabBar: TabBar(
          isScrollable: true,
          labelColor: AppColors.blueBtnRegister,
          unselectedLabelColor: AppColors.blueBtnRegister.withAlpha(100),
          indicatorColor: AppColors.blueBtnRegister,
          controller: _tabController,
          tabs: <Widget>[
            Tab(
                child: SizedBox(
                    width: 90,
                    child: Text(
                      S.of(context).all,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ))),
            Tab(
                child: SizedBox(
                    width: 90,
                    child: Text(S.of(context).cercaMi,
                        textAlign: TextAlign.center, maxLines: 1))),
            Tab(
                child: SizedBox(
                    width: 90,
                    child: Text(S.of(context).map,
                        textAlign: TextAlign.center, maxLines: 1))),
          ],
        ),
      ),
    );
  }
}
