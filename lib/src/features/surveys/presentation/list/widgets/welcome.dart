import 'package:flutter/material.dart';
import 'package:smart_cities/generated/i18n.dart';
import 'package:smart_cities/src/shared/app_images.dart';
import 'package:smart_cities/src/shared/components/firebase_storage_image.dart';
import 'package:smart_cities/src/features/auth/presentation/profile/providers/profile_provider.dart';
import 'package:smart_cities/src/shared/app_colors.dart';
import 'package:smart_cities/src/shared/components/base_view.dart';
import 'package:smart_cities/src/shared/constant.dart';
import 'package:smart_cities/src/shared/provider/view_state.dart';

class Welcome extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileProvider>(
      onProviderReady: (provider) => provider.getProfile(municipalitys: true),
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '${S.of(context).welcome} ${provider.user?.firstName ?? ''}',
                  style: kMediumTitleStyle.copyWith(
                    color: AppColors.blueBtnRegister,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),

              _buildProfile(provider),

            ],
          ),
        );



      }
    );
  }

  Widget _buildProfile(ProfileProvider provider) {
    if(!provider.isLogged)
      return Container(height: 100,);
    final visible = provider.profileState is Loaded ||
        provider.profileState is Idle;

    return Container(
      width: 55,
      height: 55,
      padding: EdgeInsets.all(8.0),
      child: ClipOval(
        child: Visibility(
          visible: visible,
          child: FirebaseStorageImage(
            referenceUrl: provider?.user?.photoURL,
            fallbackWidget: CircularProgressIndicator(),
            errorWidget: AppImages.defaultImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

  }

}
