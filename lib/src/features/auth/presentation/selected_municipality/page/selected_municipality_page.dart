import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/app.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/auth/presentation/base/widgets/user_photo.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/providers/profile_provider.dart';
import 'package:smart_cities/src/features/main/presentation/pages/main_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class SelectedMunicipalityPage extends StatefulWidget {
  static const id = "selected_municipality_page";

  @override
  _SelectedMunicipalityPageState createState() => _SelectedMunicipalityPageState();
}

class _SelectedMunicipalityPageState extends State<SelectedMunicipalityPage> {

  @override
  Widget build(BuildContext context) {

    return BaseView<ProfileProvider>(
      onProviderReady: (provider) => provider.getProfile(),
        builder: (context, provider, child) {

          final isLoading = provider.currentState is Loading ||
              provider.profileState is Loading;


          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                      width: double.infinity,
                      child: Image.asset(AppImagePaths.ellipse,
                          fit: BoxFit.cover)),
                  SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 60, bottom: 10),
                              child: Text(
                                S.of(context).welcome.toUpperCase(),
                                style: kMediumTitleStyle.copyWith(
                                  color: AppColors.white,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            UserPhoto(provider: provider),
                            Spaces.verticalSmall(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                provider.user?.firstName ?? '',
                                style: kTitleStyle.copyWith(
                                  fontSize: 35.0,
                                  color: AppColors.primaryText.withOpacity(0.5),
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Spaces.verticalSmall(),
                            Container(
                              color: AppColors.red,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(S.of(context).selectedMunicipality,
                                    style: kMediumTitleStyle.copyWith(
                                      color: Colors.white,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                            ),
                            Column(
                              children:
                                  _generateViewsMunicipality(context, provider),
                            ),

                            //SizedBox(height: 500,)
                          ],
                        ),
                  )),
                ],
              ),
            ),
          );
        }
    );

  }

  List<Widget> _generateViewsMunicipality(BuildContext context, ProfileProvider provider) {
    //print('listado de municipios ${municipalitys.length}');

    if(municipalitys!=null)
      return List<Widget>.generate(municipalitys.length, (index) {

        var selected= provider.municipality == municipalitys[index].key;

        return Container(
          color:   selected ? AppColors.green : Colors.white,
          child: Column(
            children: [
              ListTile(
                onTap: () async {
                  setState(() {
                    provider.municipality=municipalitys[index].key;
                    //Navigator.pushReplacementNamed(context, MainPage.id);
                  });
                  await provider.updateMunicipio(municipalitys[index]);
                  _process(provider);
                  //await provider.editProfile();

                },
                title: Text(municipalitys[index].value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: selected
                            ? AppColors.white
                            : AppColors.textItem,

                      fontFamily: 'Roboto',
                      fontWeight: selected ? FontWeight.bold : FontWeight.w400 ,
                    )
                ),
              ),
              Container(color: AppColors.greyButtom.withOpacity(0.5), height: 0.6,),
            ],
          ),
        );
      });
    else
      return List<Widget>();
  }


  void _process(ProfileProvider provider) {
    final currentState = provider.currentState;

    if (currentState is Loaded) {
      Navigator.pushReplacementNamed(context, MainPage.id);
    } else if (currentState is Error) {
      showDialog(
        context: context,
        builder: (context) {
          return InfoAlertDialog(
            message: S.of(context).unexpectedErrorMessage,
          );
        },
      );
    }
  }



}
