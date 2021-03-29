import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/core/error/failure.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/category_item.dart';
import 'package:smart_cities/src/features/select_sector/provider/select_sector_provider.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/header_search.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/src/shared/components/info_view.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';


import '../../../../shared/components/base_view.dart';

class SelectSectorPage extends StatefulWidget {
  static const id = "select_sector_page_route";

  const SelectSectorPage({Key key}) : super(key: key);

  @override
  _SelectedSectorPageState createState() => _SelectedSectorPageState();
}

class _SelectedSectorPageState extends State<SelectSectorPage> {
  ScrollController _scrollController;
  List<CatalogItem> _list= [];
  bool _isDisposed = false;



  set list(List<CatalogItem> newList) {
    if (_isDisposed) return;

    setState(() {
      _list = newList;
      //_headerKey.currentState.setLiked(_report.follow);
    });

  }


  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
     _isDisposed = true;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight= MediaQuery.of(context).size.height;

    return BaseView<SelectSectorProvider>(
      onProviderReady: (provider) => provider.loadData(),
      builder: (context, provider, child){
        final currentState = provider.currentState;
        final isLoading = currentState is Loading;


      if (currentState is Loaded) {
          Future.delayed(
            Duration(milliseconds: 250),
            () => list = provider.allSectores,
          );
        }

        if (currentState is Error) {
          final failure = currentState.failure;

          return _buildErrorView(context, failure, provider);
        }


        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.red,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(S.of(context).sector),
              leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back),
                ),
            ),
            body: Stack(
              children: [
                HeaderSearch(onChanged: (value)=> onChanged(value, provider) ,),
                _buildListSector(_list, screenHeight),
              ],
            ),
          ),
        );


      }
    );



   

  }



  Widget _buildListSector(List<CatalogItem> allSectores,  double screenHeight) {

    if(allSectores== null || allSectores.isEmpty)
      return Container();


    return Padding(
      padding: EdgeInsets.only(top: screenHeight*0.08),
      child: ListView.builder(
        itemCount: allSectores.length,
        controller: _scrollController,
        itemBuilder: (context, index) => CategoryItem(
          categoria: allSectores[index],
          selected: false,
          onTap: (value){
            Navigator.pop(context, value);
          },
        ),
      ),
    );


  }



  void showInfoDialog(
      String message, {
        String confirmTitle,
        String cancelTitle,
        bool cancelAction = false,
        Function onConfirm,
      }) {
    showDialog(
      context: context,
      builder: (context) => InfoAlertDialog(
        message: message,
        confirmTitle: confirmTitle,
        cancelTitle: cancelTitle,
        cancelAction: cancelAction,
        onConfirm: () {
          if (onConfirm != null) onConfirm();
        },
      ),
    );
  }

  

  void onChanged(String value, SelectSectorProvider provider) {
    print(value); //widget.provider.allSectores

    if(value.isEmpty)
      list= provider.allSectores;
    else
      list = provider.allSectores
          .where((element) => element.value.toLowerCase().contains(value.toLowerCase()))
          .toList();

    setState(() {
    });
  }


  Widget _buildErrorView(BuildContext context, Failure failure, SelectSectorProvider provider) {
    return InfoView(
      height: MediaQuery.of(context).size.height,
      image: AppImages.iconMessage,
      title: S.of(context).unexpectedErrorMessage,
      titleStyle: kMediumTitleStyle.copyWith(color: Colors.grey.shade500),
      descriptionStyle: kNormalStyle.copyWith(color: Colors.grey.shade500),
      child: btnTryAgain(provider),
    );
  }

  Widget btnTryAgain(SelectSectorProvider provider) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: RoundedButton(
            color: AppColors.blueBtnRegister,
            title: S.of(context).tryAgain,
            style: kTitleStyle.copyWith(color: AppColors.white),
            onPressed: () => provider.loadData()
        )
    );
  }
}

