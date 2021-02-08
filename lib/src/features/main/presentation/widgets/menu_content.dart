import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/auth/presentation/base/widgets/user_photo.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/providers/profile_provider.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/page/places_category_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/custom_item_list.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class MenuContent extends StatelessWidget {
  final ProfileProvider provider;
  final textStyle= TextStyle(
    color: AppColors.white,
    fontWeight:  FontWeight.bold,
  );
  
  MenuContent({Key key, this.provider}) : super(key: key);


  @override
  Widget build(BuildContext context) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spaces.verticalLarge(),
            UserPhoto(provider: provider),
            Spaces.verticalSmall(),

            CustomItemList(
              title: S.of(context).menuProfileTitle,
              onTap: () {},
              selected: false,
              isDivider: false,
              textStyle: textStyle,
            ),


          CustomItemList(
              title: S.of(context).places,
              onTap: () =>  Navigator.pushNamed(context, PlacesCategoryPage.id),
              selected: false,
              isDivider: false,
              textStyle: textStyle),


              
        ],
        ),


      );
  }

}

