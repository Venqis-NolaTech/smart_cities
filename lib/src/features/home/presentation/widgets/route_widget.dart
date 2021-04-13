import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/home/presentation/provider/home_provider.dart';
import 'package:smart_cities/src/features/auth/presentation/sign_in/pages/sign_in_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class RouteWidget extends StatelessWidget {
  final HomeProvider provider;
  final Function onAddSector;
  final Function onSelectedSector;


  RouteWidget({Key key, this.provider, this.onAddSector, this.onSelectedSector}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              buildHeaderRoute(context),
              Spaces.verticalMedium(),

              Flexible(
                child: Text(
                  //TODO pendiente para validar con recogida y el sector
                  !provider.isLogged ? S.of(context).completeYourPerfil : S.of(context).noPickupToday,
                  textAlign: TextAlign.center,
                  style: kNormalStyle.copyWith(
                    color: AppColors.blueBtnRegister,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              Spaces.verticalMedium(),

              provider.isLogged && provider.sector!=null ?
              Flexible(
                child: Text(
                  provider.sector.value,
                  textAlign: TextAlign.center,
                  style: kNormalStyle.copyWith(
                    color: AppColors.blueBtnRegister,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ) : Container(),


              Spaces.verticalMedium(),
              FlatButton(
                onPressed: () {
                  if (provider.isLogged) {
                    if (provider.sector != null) // ir a recogida
                      onSelectedSector();
                    else //ir al perfil para completar datos
                      onAddSector();
                  } else
                    SignInPage.pushNavigate(context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: AppColors.blueLight)),
                child: Text(
                  S.of(context).addSector,
                  maxLines: 1,
                  style: kSmallestTextStyle.copyWith(
                    color: AppColors.blueLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row buildHeaderRoute(BuildContext context) {
    return Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                Image.asset(AppImagePaths.iconRoute),
                Spaces.horizontalSmall(),
                Text(
                  S.of(context).route,
                  textAlign: TextAlign.center,
                  style: kMediumTitleStyle.copyWith(
                    color: AppColors.blueBtnRegister,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
  }
}
