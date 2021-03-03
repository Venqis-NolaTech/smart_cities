import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/app.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/core/entities/catalog_item.dart';
import 'package:smart_cities/src/features/auth/presentation/base/widgets/user_photo.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/providers/profile_provider.dart';
import 'package:smart_cities/src/features/main/presentation/pages/main_page.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/custom_item_list.dart';
import 'package:smart_cities/src/shared/components/info_alert_dialog.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:smart_cities/src/shared/spaces.dart';


class SelectedMunicipalityPage extends StatefulWidget {
  static const id = "selected_municipality_page";

  static pushNavigate(BuildContext context, {replace = false}) {
    replace
        ? Navigator.pushReplacementNamed(context, id)
        : Navigator.pushNamed(context, id);
  }

  @override
  _SelectedMunicipalityPageState createState() => _SelectedMunicipalityPageState();
}

class _SelectedMunicipalityPageState extends State<SelectedMunicipalityPage> {

  @override
  Widget build(BuildContext context) {

    return BaseView<ProfileProvider>(
      onProviderReady: (provider) => provider.getProfile(municipalitys: true),
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

    if(provider.municipalitys!=null)
      return List<Widget>.generate(provider.municipalitys.length, (index) {

        var selected= provider.municipality == provider.municipalitys[index].key;

        return CustomItemList(
          selected: selected,
          onTap: () => onTapMunicipality(provider, provider.municipalitys[index]),
          title: provider.municipalitys[index].value,
          isDivider: true,
        );
      });
    else
      return List<Widget>();
  }

  Future onTapMunicipality(ProfileProvider provider, CatalogItem item) async {
    setState(() {
      provider.municipality=item.key;
      //Navigator.pushReplacementNamed(context, MainPage.id);
    });
    await provider.updateMunicipio(item);
    _process(provider);
    //await provider.editProfile();
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
