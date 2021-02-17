import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/places/domain/entities/place.dart';
import 'package:smart_cities/src/features/places/presentation/place_schedule/page/place_schedule_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/custom_card.dart';
import 'package:smart_cities/src/shared/constant.dart';
import '../../../../../shared/spaces.dart';


class PlaceContentService extends StatelessWidget {
  final Place place;

  const PlaceContentService({Key key, this.place}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ListTile(
          onTap: () => Navigator.pushNamed(context, SchedulePlacePage.id, arguments: place),
          leading: Icon(MdiIcons.clockTimeThreeOutline),
          title: Text(S.of(context).scheduleSite),
        ),
        Divider(),
        ListTile(
          leading: Icon(MdiIcons.bookOpen),
          title: Text(S.of(context).reserve),
        ),
        Divider(),
        ListTile(
          leading: Icon(MdiIcons.calendarMonth),
          title: Text(S.of(context).events),
        ),
        Divider(),
        Container(
          padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 12),
          child: Text(
            S.of(context).services,
            textAlign: TextAlign.start,
            style: kTitleStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.blueButton),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: _buildIconsServices(context, orientation ),
        ),
        

      ],
    );
  }

  Widget _buildIconsServices(BuildContext context, Orientation orientation) {

    List<Widget> childrens=[];

    if(place.services==null)
      return Container();

    if(place.services.family){
      childrens.add(_buildIcon(AppImages.family, S.of(context).family));
    }

    if(place.services.security){
      childrens.add(_buildIcon(AppImages.security, S.of(context).security));
    }

    if(place.services.bicycleZone){
      childrens.add(_buildIcon(AppImages.bicycle, S.of(context).bicycleZone));
    }

    if(place.services.exerciseZone){
      childrens.add(_buildIcon(AppImages.running, S.of(context).exerciseZone));
    }


    if(place.services.childrensZone){
      childrens.add(_buildIcon(AppImages.games, S.of(context).childrensZone));
    }


    if(place.services.restaurant){
      childrens.add(_buildIcon(AppImages.restaurant, S.of(context).restaurant));
    }

    if(place.services.toilets){
      childrens.add(_buildIcon(AppImages.bath, S.of(context).toilets));
    }

    if(place.services.cleaning){
      childrens.add(_buildIcon(AppImages.cleanning, S.of(context).cleaning));
    }


    return  GridView.count(
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4,
      shrinkWrap: true,
      childAspectRatio: 3/4,
      children: childrens,
    );

  }

  Widget _buildIcon(Widget  image, String text){
     return CustomCard(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      backgroundColor: AppColors.blueLight.withOpacity(0.09),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        children: [
          image,
          Spaces.verticalMedium(),
          Flexible(child: Text(text, maxLines: 2, 
          textAlign: TextAlign.center, 
           style: TextStyle(
                    color: AppColors.blueBtnRegister,
                    fontWeight: FontWeight.bold) )
          )
        ],
      ),
    );

  }



}
