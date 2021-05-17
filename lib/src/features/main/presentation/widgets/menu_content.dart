import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/pages/profile_page.dart';
import 'package:smart_cities/src/features/auth/presentation/base/widgets/user_photo.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/providers/profile_provider.dart';
import 'package:smart_cities/src/features/auth/presentation/sign_in/pages/sign_in_page.dart';
import 'package:smart_cities/src/features/blog/presentation/pages/blog_page.dart';
import 'package:smart_cities/src/features/places/presentation/places_list/page/places_category_page.dart';
import 'package:smart_cities/src/features/splash/presentation/pages/splash_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';
import 'package:smart_cities/src/features/surveys/presentation/list/pages/surveys_page.dart';
import 'package:smart_cities/src/features/surveys/presentation/list/pages/recents_surveys_user.dart';


class MenuContent extends StatelessWidget {
  final ProfileProvider provider;
  Map<String, Function> options= Map();
  List<Widget> widget=[];

  final Function onFunctionPickup;
  final Function onFunctionPayment;


  final textStyle= kTitleStyle.copyWith(
    color: AppColors.white,
    fontWeight:  FontWeight.bold,
  );

  MenuContent({Key key, this.provider, this.onFunctionPickup, this.onFunctionPayment}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    /*final Map<String, Function> options= {
      S.of(context).menuProfileTitle: ProfilePage.id,
      S.of(context).places: PlacesCategoryPage.id,
      S.of(context).news:  BlogPage.id,
      S.of(context).transport: '',
      S.of(context).paymentMethod: '',
      S.of(context).pickup: '',
      S.of(context).newPoll: '',
      S.of(context).events: '',
      S.of(context).chat: ''
    };*/

    widget.addAll([
      SizedBox(width: double.infinity),
      Spaces.verticalLargest(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          S.of(context).menuTittle,
          textAlign: TextAlign.center,
          style: kBigTitleStyle.copyWith(
            color: AppColors.white,
          ),
        ),
      ),

      if(!provider.isLogged)
        Spaces.verticalLarge(),
    ]);


    _buildProfile(context);
    _buildOption(context);


      return Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 80.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget
              ),
            ),
          ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width: 100, height: 1, color: AppColors.white,),
            InkWell(
              onTap: () => _onLogoutPressed(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 24, top: 12),
                child: Text(
                    !provider.isLogged ? S.of(context).login : S.of(context).logout,
                    textAlign: TextAlign.center,
                    style: textStyle),
              ),
            )
          ],
        )
      ],
      );
  }

  void _buildProfile(BuildContext context){

    if(provider.isLogged){
      widget.addAll([
        Spaces.verticalSmall(),
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

      widget.add(ItemList(
          title: S.of(context).menuProfileTitle,
          onTap: ()=> Navigator.pushNamed(context, ProfilePage.id),
          textStyle: textStyle));

    }
  }

  void _onLogoutPressed(BuildContext context) async {
    if(!provider.isLogged){
      SignInPage.pushNavigate(context);
    }else{
      await provider.logout();
      SplashPage.pushNavigate(context);
    }
  }

  void _buildOption(BuildContext context) {
    //S.of(context).places: PlacesCategoryPage.id,
    widget.add(ItemList(
        title: S.of(context).places,
        onTap: ()=> Navigator.pushNamed(context, PlacesCategoryPage.id),
        textStyle: textStyle));

    //S.of(context).news:  BlogPage.id,
    widget.add(ItemList(
        title: S.of(context).news,
        onTap: ()=> Navigator.pushNamed(context, BlogPage.id),
        textStyle: textStyle));

    widget.add(ItemList(
        title: S.of(context).transport,
        onTap: null,
        textStyle: textStyle));

    widget.add(ItemList(
        title: S.of(context).paymentMethod,
        onTap: onFunctionPayment,
        textStyle: textStyle));

    widget.add(ItemList(
        title: S.of(context).pickup,
        onTap: onFunctionPickup,
        textStyle: textStyle));

    widget.add(ItemList(
        title: S.of(context).surveys,
        onTap: (){
          if(!provider.isLogged){
            SignInPage.pushNavigate(context);
          }else{
      
            if(provider.user.kind== 'USUARIO'){
              Navigator.pushNamed(context, RecentSurveysUser.id);
            }else
              Navigator.pushNamed(context, SurveysPage.id);
          }
        },
        textStyle: textStyle));

    widget.add(ItemList(
        title: S.of(context).events,
        onTap: null,
        textStyle: textStyle));

    widget.add(ItemList(
        title: S.of(context).chat,
        onTap: null,
        textStyle: textStyle));

  }




}


class ItemList extends StatelessWidget{
  final Function onTap;
  final String title;
  final TextStyle textStyle;

  ItemList({Key key, this.onTap, this.title, this.textStyle}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 24, top: 12),
          child: Text(
              title,
              textAlign: TextAlign.center,
              style: textStyle),
      ),
    );
  }

}

