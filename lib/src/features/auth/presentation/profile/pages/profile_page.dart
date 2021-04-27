import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/widgets/profile_form_content.dart';
import 'package:smart_cities/src/features/auth/presentation/base/widgets/user_photo.dart';


import '../../../../../shared/app_colors.dart';
import '../../../../../shared/components/base_view.dart';
import '../../../../../shared/provider/view_state.dart';
import '../providers/profile_provider.dart';
import 'package:smart_cities/src/shared/spaces.dart';

class ProfilePage extends StatelessWidget {
  static const id = "profile_page";

  static pushNavigate(BuildContext context, {replace = false}) {
    replace
        ? Navigator.pushReplacementNamed(context, id)
        : Navigator.pushNamed(context, id);
  }


  ProfilePage({Key key}) : super(key: key);

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
            body: SingleChildScrollView(
              child: Column(
                children: [

                  Stack(
                    children: [
                      Column(
                        children: [
                          Container(height: screenHeght*0.2, color: AppColors.red),
                          Container(
                            height: screenHeght*0.05,
                            width: double.infinity,
                            color: AppColors.greyButtom.withOpacity(0.2))
                        ],
                      ),

                      Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Spaces.verticalLargest(),
                            UserPhoto(provider: provider)
                          ],
                        ),
                      ),

                      SafeArea(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(Icons.arrow_back), 
                          color: AppColors.white, 
                          onPressed: ()=> Navigator.pop(context)
                          ),
                      ))
                    ],
                  ),

                  ProfileFormContent(
                    provider: provider,
                    ),
              ],
              ),
            )
        ),
        );



      },

    );
  }


}
