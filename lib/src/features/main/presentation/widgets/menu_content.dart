import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/pages/profile_page.dart';
import 'package:smart_cities/src/features/auth/presentation/base/widgets/user_photo.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/providers/profile_provider.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/page/places_category_page.dart';
import 'package:smart_cities/src/features/splash/presentation/pages/splash_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/custom_item_list.dart';
import 'package:smart_cities/src/shared/constant.dart';
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
    List<Widget> widget=[];
    final Map<String, String> options= {
      S.of(context).menuProfileTitle: ProfilePage.id,
      S.of(context).places: PlacesCategoryPage.id,
      S.of(context).news: '',
      S.of(context).transport: '',
      S.of(context).paymentMethod: '',
      S.of(context).pickup: '',
      S.of(context).newPoll: '',
      S.of(context).events: '',
      S.of(context).chat: ''
    };
    widget.addAll([
      Spaces.verticalLarge(),
      UserPhoto(provider: provider),
      Spaces.verticalSmall(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          provider.user?.nickName ?? '',
          style: kBigTitleStyle.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    ]);

    options.forEach((key, value) {
      widget.add(CustomItemList(
          title: key,
          onTap: value.isEmpty ? null : () =>  Navigator.pushNamed(context, value, arguments: null),
          selected: false,
          isDivider: false,
          textStyle: textStyle));
    });

    widget.add(CustomItemList(
        title: S.of(context).logout,
        onTap: ()=> _onLogoutPressed(context),
        selected: false,
        isDivider: false,
        textStyle: textStyle));

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: widget  
        ),


      );
  }


  void _onLogoutPressed(BuildContext context) async {
    await provider.logout();

    SplashPage.pushNavigate(context);
  }

}

