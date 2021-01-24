import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/providers/create_report_provider.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/widget/bottom_navigation.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/widget/category_item.dart';
import 'package:smart_cities/src/features/resports/presentation/new_report/widget/header_search.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';
import 'package:smart_cities/src/shared/constant.dart';


class SelectedNeighborhoodPage extends StatefulWidget {
  static const id = "selected_neighborhood_page";
  final CreateReportProvider provider;

  const SelectedNeighborhoodPage({Key key, this.provider}) : super(key: key);


  @override
  _SelectedSectorPageState createState() => _SelectedSectorPageState();
}

class _SelectedSectorPageState extends State<SelectedNeighborhoodPage> {
  ScrollController _scrollController;
  var alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
  List list= [];

  @override
  void initState() {
    _scrollController = ScrollController();
      list= widget.provider.allNeighborhood;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight= MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.red,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(S.of(context).neighborhood),
        actions: [
          FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                S.of(context).cancel,
                style: kSmallTextStyle.copyWith(color: AppColors.white),
              ))
        ],
      ),
      body: Stack(
        children: [
          HeaderSearch(onChanged: (value)=> onChanged(value)),
          _buildListNeighborhood(list, widget.provider, screenHeight),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BottomNavigationReport(
                textOnBack: S.of(context).cancel,
                textOnNext: S.of(context).toSelect,
                onBack: ()=> Navigator.of(context).pop(),
                onNext: _onNext,
              ),
            ],
          ),


        ],
      ),
    );

  }

  Widget _buildListNeighborhood(List<CatalogItem> allNeighborhood,  CreateReportProvider provider, double screenHeight) {

    return Padding(
      padding: EdgeInsets.only(top: screenHeight*0.08),
      child: ListView.builder(
        itemCount: allNeighborhood.length,
        controller: _scrollController,
        itemBuilder: (context, index) => CategoryItem(
          categoria: allNeighborhood[index],
          selected: provider.selectedNeighborhood== null ? false : provider.selectedNeighborhood.key==allNeighborhood.elementAt(index).key,
          onTap: (value){
            provider.selectedNeighborhood=value;
            setState(() {

            });
            //Navigator.of(context).pop();
          },
        ),
      ),
    );


  }
  void _onNext() {
    if(widget.provider.selectedNeighborhood!= null )
      Navigator.of(context).pop();
    else
      showInfoDialog(S.of(context).neighborhoodValid);
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

  void onChanged(String value) {
    print(value); //widget.provider.allSectores

    if(value.isEmpty)
      list= widget.provider.allNeighborhood;
    else
      list = widget.provider.allNeighborhood
          .where((element) => element.value.toLowerCase().contains(value.toLowerCase()))
          .toList();

    setState(() {
    });
  }

}

