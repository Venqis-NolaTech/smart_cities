import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/features/auth/presentation/base/widgets/user_photo.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/providers/profile_provider.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/widgets/profile_form_content.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/components/rounded_button.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';
import 'package:smart_cities/src/shared/spaces.dart';



class ValidateAccountPage extends StatelessWidget {
  static const id = "validate_account_page";

  @override
  Widget build(BuildContext context) {

    var screenHeght= MediaQuery.of(context).size.height;



    return BaseView<ProfileProvider>(
      onProviderReady: (provider) => provider.getProfile(),
      builder: (context, provider, child){

        final isLoading = provider.currentState is Loading ||
            provider.profileState is Loading;


        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            body: Column(
              children: [

                Stack(
                  children: [
                    Container(height: screenHeght*0.2, color: AppColors.red),

                    Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Spaces.verticalLargest(),
                          UserPhoto(provider: provider)
                        ],
                      ),
                    )
                ],
                ),

                ProfileFormContent(provider: provider),

                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: RoundedButton(
                        color: AppColors.blueBtnRegister,
                        title: S.of(context).validate.toUpperCase(),
                        style: kTitleStyle.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        ),
                        onPressed: () => provider.validateEmail()))
            ],
            )
        ),
        );



      },

    );

  }


  Widget getTittle(String text){
    return Text(text, style: kSmallestTextStyle);
  }

  Widget getButtomValidate(BuildContext context){


    return FlatButton(
        onPressed: ()=> Navigator.pushNamed(context, ValidateAccountPage.id),
        color: AppColors.blueBtnRegister,
        textColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Text(S.of(context).validate)
    );

  }


}
