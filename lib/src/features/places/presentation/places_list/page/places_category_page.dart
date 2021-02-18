import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/page/places_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';

import '../../../../../shared/components/base_view.dart';
import '../provider/places_provider.dart';
import '../../../../../shared/provider/view_state.dart';
import '../../../../../shared/components/custom_item_list.dart';


class PlacesCategoryPage extends StatefulWidget {
  static const id = "places_category_page";
  final String category;

  const PlacesCategoryPage({Key key, this.category}) : super(key: key);


  @override
  _PlacesCategoryPageState createState() => _PlacesCategoryPageState();
}

class _PlacesCategoryPageState extends State<PlacesCategoryPage> {
  List<CatalogItem> _categorys=[];
  bool _categoryLoaded = false;
  bool _isDisposed = false;


  set categorys(List<CatalogItem> newList) {
    if (_isDisposed) return;
    setState(() {
      _categorys = newList;
    });
  }



  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BaseView<PlacesProvider>(
      onProviderReady: (provider) => provider.loadCategory(),
      builder: (context, provider, child) {
        final currentState = provider.currentState;


        if (currentState is Error) {
          final failure = currentState.failure;

          return _buildErrorView(context, failure, provider);
        }


        if (!_categoryLoaded && currentState is Loaded<List<CatalogItem>>) {
          Future.delayed(
            Duration(milliseconds: 250),
                () => categorys = currentState.value,
          );

          _categoryLoaded = true;
        }

        return ModalProgressHUD(
          inAsyncCall: currentState is Loading,
          child: Scaffold(
            appBar: AppBar(
                title: Text(S.of(context).places),
                centerTitle: true,
                backgroundColor: AppColors.red,
                leading: IconButton(
                  icon: Icon(MdiIcons.arrowLeft),
                  color: AppColors.white,
                  onPressed: () {
                    if(widget.category!=null){
                      Navigator.pushReplacementNamed(context, PlacesPage.id, arguments: widget.category);
                    }else 
                      Navigator.pop(context);

                  },
                ),
                ),
            body: ListView.builder(
                itemCount: _categorys.length,
                itemBuilder: (context, index) => CustomItemList(
                      selected: provider.selectedCategory== null ? false : provider.selectedCategory.key == _categorys[index].key,//provider.municipality == municipalitys[index].key
                      onTap: () => onTapCatgeory(provider, _categorys[index]),
                      title: _categorys[index].value,
                      isDivider: true,
                    )),
          ),
        );
      },
    );
  }

  void onTapCatgeory(PlacesProvider provider, CatalogItem category) {
    provider.selectedCategory= category;
    Future.delayed(Duration(milliseconds: 250),
        () => Navigator.pushReplacementNamed(context, PlacesPage.id, arguments: provider.selectedCategory.key));
  
  }

  Widget _buildErrorView(BuildContext context, Failure failure, PlacesProvider provider) {
    return InfoView(
      height: MediaQuery.of(context).size.height*0.7,
      image: AppImages.iconMessage,
      title: S.of(context).empyteReport,
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      description: S.of(context).unexpectedErrorMessage,
      descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
      child: btnTryAgain(provider),
    );
  }

  Widget btnTryAgain(PlacesProvider provider,){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: RoundedButton(
            color: AppColors.blueBtnRegister,
            title: S.of(context).tryAgain,
            style: kTitleStyle.copyWith(color: AppColors.white),
            onPressed:
                () => provider.loadCategory()));
  }


}