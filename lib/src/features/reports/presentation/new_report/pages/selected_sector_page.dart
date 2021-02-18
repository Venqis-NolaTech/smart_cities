import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/providers/create_report_provider.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/bottom_navigation.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/category_item.dart';
import 'package:smart_cities/src/features/reports/presentation/new_report/widget/header_search.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';
import 'package:smart_cities/src/shared/constant.dart';


class SelectedSectorPage extends StatefulWidget {
  static const id = "selected_sector_page";
  final CreateReportProvider provider;

  const SelectedSectorPage({Key key, this.provider}) : super(key: key);


  @override
  _SelectedSectorPageState createState() => _SelectedSectorPageState();
}

class _SelectedSectorPageState extends State<SelectedSectorPage> {
  ScrollController _scrollController;
  var alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"];
  List list= [];

  @override
  void initState() {
    _scrollController = ScrollController();
    list= widget.provider.allSectores;
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
        title: Text(S.of(context).sector),
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
          HeaderSearch(onChanged: (value)=> onChanged(value) ,),
          _buildListSector(list, widget.provider, screenHeight),


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

  void onChanged(String value) {
    print(value); //widget.provider.allSectores

    if(value.isEmpty)
      list= widget.provider.allSectores;
    else
      list = widget.provider.allSectores
          .where((element) => element.value.toLowerCase().contains(value.toLowerCase()))
          .toList();

    setState(() {
    });
  }

  Widget _buildListSector(List<CatalogItem> allSectores,  CreateReportProvider provider, double screenHeight) {

    return Padding(
      padding: EdgeInsets.only(top: screenHeight*0.08),
      child: ListView.builder(
        itemCount: allSectores.length,
        controller: _scrollController,
        itemBuilder: (context, index) => CategoryItem(
          categoria: allSectores[index],
          selected: provider.selectedSector== null ? false : provider.selectedSector.key==allSectores.elementAt(index).key,
          onTap: (value){
            provider.selectedSector=value;
            provider.selectedNeighborhood= null;
            setState(() {

            });
            //Navigator.of(context).pop();
          },
        ),
      ),
    );


  }




  void _onNext() {
    if(widget.provider.selectedSector!= null )
      Navigator.of(context).pop();
    else
      showInfoDialog(S.of(context).sectorValid);
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
}

