import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/custom_card.dart';
import 'package:smart_cities/src/shared/components/header_route.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';

//cuando sacar la basura
class WhenTakeOutTrashPage extends StatelessWidget {
  static const id = "when_take_out_trash_page";

  final CatalogItem sector;

  WhenTakeOutTrashPage({Key key, @required this.sector}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.red,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(S.of(context).takeOutTrash),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: HeaderRoute(tittle: sector.value, widget: buildHeader(context),),
              ),
              Spaces.verticalMedium(),

              Text(S.of(context).whenTakeOutTrash, style: kTitleStyle.copyWith(color: AppColors.blueBtnRegister)),
              Spaces.verticalMedium(),
              buildGrid(context),
              Spaces.verticalMedium(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text(S.of(context).messageTrash, style: kNormalStyle.copyWith(color: AppColors.blueBtnRegister), textAlign: TextAlign.center,),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Row(children: [
      Flexible(child: Text(S.of(context).rememberTakeOutTrash, style: kTitleStyle.copyWith(color: AppColors.white),)),
      Spaces.horizontalSmall(),
      Text('Horario: 9:00 am', style: kTitleStyle.copyWith(color: AppColors.white))
    ],);
  }

  Widget buildGrid(BuildContext context) {
    List<Widget> childrens=[];

    //agregar Lunes
    childrens.add(_buildCard(S.of(context).monday, 'Horario 9:00 am', context));
    //agregar Martes
    childrens.add(_buildCard(S.of(context).tuesday, 'Horario 10:00 am', context));
    //agregar Miercoles
    childrens.add(_buildCard(S.of(context).wednesday, 'Horario 10:00 am', context));
    //agregar Jueves
    childrens.add(_buildCard(S.of(context).thursday, 'No recogida de basura', context));
    //agregar Viernes
    childrens.add(_buildCard(S.of(context).friday, 'Horario 10:00 am', context));
    //agregar Sabado
    childrens.add(_buildCard(S.of(context).saturday, 'Horario 10:00 am', context));
    //agregar Domingo
    childrens.add(_buildCard(S.of(context).sunday, 'No recogida de basura', context));


    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      //spacing: 8.0,
      children: childrens,
    );

    /*return  Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          shrinkWrap: true,
          childAspectRatio: 1.5,
          children: childrens,
        ),

        _buildCard(S.of(context).sunday, 'No recogida de basura')




      ],
    );*/

  }


  Widget _buildCard(String title, String schedule, BuildContext context){
    return CustomCard(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      backgroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      child: Container(
        width:  MediaQuery.of(context).size.width / 2.7,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Text(title, maxLines: 2,
                textAlign: TextAlign.center,
                style: kTitleStyle.copyWith(
                    color: AppColors.blueBtnRegister,
                    fontWeight: FontWeight.bold) )),
            Spaces.verticalMedium(),
            Flexible(child: Text(schedule, maxLines: 2,
                textAlign: TextAlign.center,
                style: kTitleStyle.copyWith(
                    color: AppColors.blueBtnRegister) )
            )
          ],
        ),
      ),
    );

  }



}
